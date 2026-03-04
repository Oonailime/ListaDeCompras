import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_de_compras/app/features/model/usuario.dart';
// bcrypt import kept for legacy migration verification
import 'package:bcrypt/bcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManager {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'users';

  static Future<void> registerUser(String email, String username, String plainPassword) async {
    try {
      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: plainPassword);
      String uid = cred.user?.uid ?? '';
      Usuario user = Usuario(
        username: username,
        uid: uid,
        passwordHash: '',
      );
      // Guardar em /users/{uid} não em /users/{username}
      await _firestore.collection(_collection).doc(uid).set(user.toJson());
    } on FirebaseAuthException catch (authError) {
      throw Exception('Auth error (${authError.code}): ${authError.message}');
    }
  }

  // Efetua login. Se o identificador contém '@', trata como email; caso
  // contrário, tenta rota legada com nome de usuário e hash (deprecated).
  // Retorna o nome de usuário associado ou null em caso de falha.
  static Future<String?> loginUser(String emailOrUsername, String plainPassword) async {
    if (emailOrUsername.contains('@')) {
      try {
        UserCredential cred = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: emailOrUsername, password: plainPassword);
        String? uid = cred.user?.uid;
        if (uid == null) return null;
        DocumentSnapshot doc = await _firestore.collection(_collection).doc(uid).get();
        if (doc.exists) {
          return (doc.data() as Map<String, dynamic>)['username'] as String?;
        }
        return null;
      } on FirebaseAuthException catch (e) {
        throw Exception('Auth error (${e.code}): ${e.message}');
      }
    }

    // legacy path using username
    String username = emailOrUsername;
    final query = await _firestore
        .collection(_collection)
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      DocumentSnapshot doc = query.docs.first;
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      String storedHash = userData['passwordHash'] ?? '';
      if (storedHash.isNotEmpty && BCrypt.checkpw(plainPassword, storedHash)) {
        // migrar: create auth account com email sintético
        final String email = '$username@local';
        UserCredential newCred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: plainPassword);
        String newUid = newCred.user?.uid ?? '';
        await doc.reference.update({
          'uid': newUid,
          'passwordHash': FieldValue.delete(),
        });
        return username;
      }
    }
    return null;
  }

  // legado: buscar por username em /users/{uid} usando query
  static Future<Usuario?> getUserByUsername(String username) async {
    final query = await _firestore
        .collection(_collection)
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      return Usuario.fromJson(query.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }

  // encerra sessão no FirebaseAuth
  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Método para adicionar uma nova lista de compras ao usuário
  static Future<void> addListaDeCompras(String username, String listaId) async {
    DocumentReference userDoc = _firestore.collection(_collection).doc(username);
    DocumentSnapshot doc = await userDoc.get();

    if (doc.exists) {
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      List<String> listasDeCompras = List<String>.from(userData['listasDeCompras'] ?? []);
      if (!listasDeCompras.contains(listaId)) {
        listasDeCompras.add(listaId);
        await userDoc.update({'listasDeCompras': listasDeCompras});
      }
    }
  }

  // Adicionar convite pendente ao usuário
  static Future<void> addConvitePendente(String username, String listaId) async {
    DocumentReference userDoc = _firestore.collection(_collection).doc(username);
    DocumentSnapshot doc = await userDoc.get();

    if (doc.exists) {
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      List<String> convitesPendentes = List<String>.from(userData['convitesPendentes'] ?? []);
      if (!convitesPendentes.contains(listaId)) {
        convitesPendentes.add(listaId);
        await userDoc.update({'convitesPendentes': convitesPendentes});
      }
    }
  }

  // Aceitar convite pendente e adicionar lista compartilhada
  static Future<void> aceitarConvite(String username, String listaId) async {
    DocumentReference userDoc = _firestore.collection(_collection).doc(username);
    DocumentSnapshot doc = await userDoc.get();

    if (doc.exists) {
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      List<String> listasDeCompras = List<String>.from(userData['listasDeCompras'] ?? []);
      List<String> convitesPendentes = List<String>.from(userData['convitesPendentes'] ?? []);

      if (convitesPendentes.contains(listaId)) {
        convitesPendentes.remove(listaId);
        if (!listasDeCompras.contains(listaId)) {
          listasDeCompras.add(listaId);
          await userDoc.update({'listasDeCompras': listasDeCompras});
        }
        await userDoc.update({'convitesPendentes': convitesPendentes});
      }
    }
  }

}

