import 'package:flutter/material.dart';

class AddListDialog extends StatefulWidget {
  final Function(String) onAdd;
  final String dialogTitle;
  final String initialText;

  AddListDialog({
    super.key,
    required this.onAdd,
    this.dialogTitle = 'Adicionar Nova Lista',
    this.initialText = '',
  });

  @override
  _AddListDialogState createState() => _AddListDialogState();
}

class _AddListDialogState extends State<AddListDialog> {
  final TextEditingController _textFieldController = TextEditingController();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _textFieldController.text = widget.initialText;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.dialogTitle),
      content: TextField(
        controller: _textFieldController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: 'Nome da lista',
          errorText: _errorText,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.red[900])),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                widget.dialogTitle.contains('Adicionar') ? 'Adicionar' : 'Salvar',
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                if (_textFieldController.text.isEmpty) {
                  setState(() {
                    _errorText = 'O nome da lista não pode estar vazio';
                  });
                } 
                if(!(_textFieldController.text.isEmpty)) {
                  final String nomeLista = _textFieldController.text;
                  widget.onAdd(nomeLista);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
