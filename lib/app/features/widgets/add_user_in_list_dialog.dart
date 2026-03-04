import 'package:flutter/material.dart';

class AddUserInListDialog extends StatelessWidget {
  final Function(String) onAdd;

  const AddUserInListDialog({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Usuário à Lista'),
      content: TextField(
        decoration: const InputDecoration(
          hintText: 'Nome do usuário',
        ),
        onChanged: (value) {
          // Implemente lógica para buscar o usuário pelo nome, se necessário
        },
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Adicionar'),
          onPressed: () {
            // Implemente lógica para adicionar o usuário à lista
            onAdd('Usuário adicionado'); // Exemplo simples, passando o nome do usuário
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
