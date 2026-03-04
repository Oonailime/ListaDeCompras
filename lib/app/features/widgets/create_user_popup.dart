import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../manager/user_manager.dart';

class CreateUserPopup extends StatefulWidget {
  const CreateUserPopup({super.key});

  @override
  _CreateUserPopupState createState() => _CreateUserPopupState();
}

class _CreateUserPopupState extends State<CreateUserPopup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cadastre-se'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _usernameController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Nome de Usuário',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                prefixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Icon(
                    _isPasswordVisible ? Icons.lock_open : Icons.lock,
                  ),
                ),
                labelText: 'Senha',
                border: const OutlineInputBorder(),
              ),
              obscureText: !_isPasswordVisible,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _confirmPasswordController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                prefixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  child: Icon(
                    _isConfirmPasswordVisible ? Icons.lock_open : Icons.lock,
                  ),
                ),
                labelText: 'Confirme a Senha',
                border: const OutlineInputBorder(),
              ),
              obscureText: !_isConfirmPasswordVisible,
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
          ),
          onPressed: _isLoading ? null : () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
          ),
          onPressed: _isLoading ? null : _handleRegister,
          child: const Text('Criar'),
        ),
      ],
    );
  }

  Future<void> _handleRegister() async {
    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Validações
    if (email.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError('Por favor, preencha todos os campos.');
      return;
    }

    if (!email.contains('@')) {
      _showError('Por favor, insira um email válido.');
      return;
    }

    if (password != confirmPassword) {
      _showError('As senhas não correspondem.');
      return;
    }

    if (password.length < 6) {
      _showError('A senha deve ter no mínimo 6 caracteres.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Chama UserManager.registerUser que cria no Firebase Auth e Firestore
      await UserManager.registerUser(email, username, password);

      if (!mounted) return;

      // Fechar popup
      Navigator.of(context).pop();

      // Mostrar sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário criado com sucesso! Faça login agora.'),
          duration: Duration(seconds: 2),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _showError(_getAuthErrorMessage(e.code));
    } catch (e) {
      _showError('Erro ao criar usuário: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Este email já está registrado.';
      case 'weak-password':
        return 'A senha é muito fraca. Use pelo menos 6 caracteres.';
      case 'invalid-email':
        return 'Email inválido.';
      default:
        return 'Erro ao criar usuário: $code';
    }
  }
}
