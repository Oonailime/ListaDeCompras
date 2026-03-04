import 'package:flutter/material.dart';

class RemoveListDialog extends StatefulWidget {
  final String listName;

  const RemoveListDialog({super.key, 
    required this.listName,
  });

  @override
  _RemoveListDialogState createState() => _RemoveListDialogState();
}

class _RemoveListDialogState extends State<RemoveListDialog> {
  

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar Exclusão'),
      content:
          Text('Tem certeza que deseja excluir a lista "${widget.listName}"?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop(); 
          },
        ),
        TextButton(
          child: const Text('Excluir'),
          onPressed: () {
            Navigator.of(context).pop(true); 
          },
        ),
      ],
    );
  }
}
