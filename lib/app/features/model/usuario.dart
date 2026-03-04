class Usuario {
  String username;
  String uid; // uid do Firebase Auth
  String passwordHash; // usado apenas para migração de contas antigas
  List<String> listasDeCompras; 
  List<String> convitesPendentes; 

  Usuario({
    required this.username,
    required this.uid,
    required this.passwordHash,
    this.listasDeCompras = const [],
    this.convitesPendentes = const [], 
  });

  // Método para converter usuário para JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'uid': uid,
      'passwordHash': passwordHash,
      'listasDeCompras': listasDeCompras,
      'convitesPendentes': convitesPendentes,
    };
  }

  // Método para criar usuário a partir de JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      username: json['username'],
      uid: json['uid'] ?? '',
      passwordHash: json['passwordHash'] ?? '',
      listasDeCompras: List<String>.from(json['listasDeCompras'] ?? []),
      convitesPendentes: List<String>.from(json['convitesPendentes'] ?? []),
    );
  }
}