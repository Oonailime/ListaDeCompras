// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_de_compras/app/features/model/listadecompra.dart';
import 'package:lista_de_compras/app/features/model/produto.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = Uuid();

  Future<List<ListaDeCompra>> loadListasDeCompras(String username) async {
    try {
      final userLists = await _firestore
          .collection('listas_de_compras')
          .where('username', isEqualTo: username)
          .get();

      final sharedLists = await _firestore
          .collection('convites_pendentes')
          .where('toUsername', isEqualTo: username)
          .where('status', isEqualTo: 'aceito')
          .get();

      List<ListaDeCompra> loadedLists = [];
      for (var doc in userLists.docs) {
        final data = doc.data();
        _addListaFromFirestoreData(doc.id, data, loadedLists);
      }
      for (var invite in sharedLists.docs) {
        final listaDoc = await _firestore
            .collection('listas_de_compras')
            .doc(invite['idLista'])
            .get();
        final data = listaDoc.data();
        if (data != null) {
          _addListaFromFirestoreData(invite['idLista'], data, loadedLists);
        }
      }
      return loadedLists;
    } catch (e) {
      throw Exception('Erro ao carregar listas: $e');
    }
  }

  void _addListaFromFirestoreData(String id, Map<String, dynamic> data, List<ListaDeCompra> loadedLists) {
    List<Produto> produtosList = [];
    if (data['produtos'] != null) {
      produtosList = (data['produtos'] as List<dynamic>)
          .map((item) => Produto(
                nomeProduto: item['nomeProduto'],
                preco: item['preco'],
                quantidade: item['quantidade'],
                categoria: item['categoria'],
                isChecked: item['isChecked'],
              ))
          .toList();
    }

    loadedLists.add(ListaDeCompra(
      id: id,
      nome: data['nome'] ?? 'Lista Sem Nome',
      preco: (data['preco'] ?? 0.0).toDouble(),
      diaMesAno: data['diaMesAno'] ?? 'Lista Sem Data',
      produtos: produtosList,
    ));
  }

  Future<void> saveListasDeCompras(String username, List<ListaDeCompra> listasDeCompras) async {
    final batch = _firestore.batch();

    for (var item in listasDeCompras) {
      final docRef = _firestore.collection('listas_de_compras').doc(item.id);

      batch.set(docRef, {
        'nome': item.nome,
        'preco': item.preco,
        'username': username,
        'diaMesAno': item.diaMesAno,
        'produtos': item.produtos.map((produto) => produto.toJson()).toList(),
      });
    }

    await batch.commit();
  }

  Future<void> deleteLista(String id) async {
    try {
      await _firestore.collection('listas_de_compras').doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao excluir lista: $e');
    }
  }

  Future<void> addUserToList(String fromUsername, String toUsername, String idLista) async {
    try {
      await _firestore.collection('convites_pendentes').add({
        'fromUsername': fromUsername,
        'toUsername': toUsername,
        'idLista': idLista,
        'status': 'pendente',
      });
    } catch (e) {
      throw Exception('Erro ao enviar convite: $e');
    }
  }

  Future<void> addNewList(String username, String newListName, ListaDeCompra newList) async {
    try {
      await _firestore.collection('listas_de_compras').doc(newList.id).set({
        'nome': newListName,
        'preco': 0.0,
        'username': username,
        'diaMesAno': newList.diaMesAno,
        'produtos': [],
      });
    } catch (e) {
      throw Exception('Erro ao adicionar lista: $e');
    }
  }
}
