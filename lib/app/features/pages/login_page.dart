import 'package:lista_de_compras/app/features/widgets/create_user_popup.dart';
import 'package:flutter/material.dart';
import 'main_page.dart';
import '../manager/user_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _login() async {
    String emailOrUsername = _emailController.text.trim();
    String password = _passwordController.text;

    if (emailOrUsername.isEmpty || password.isEmpty) {
      _showError('Email ou usuário e senha são obrigatórios.');
      return;
    }

    setState(() => _isLoading = true);
    String? username;
    try {
      username = await UserManager.loginUser(emailOrUsername, password);
    } catch (e) {
      _showError(e.toString());
      setState(() => _isLoading = false);
      return;
    }
    setState(() => _isLoading = false);

    if (username != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', username!);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPageView(username: username!)),
      );
    } else {
      _showError('Email/usuário ou senha incorretos.');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro de Login'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iBuy'),
        backgroundColor: const Color.fromARGB(255, 88, 156, 95),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: const Color(0xFFD2F8D6),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'lib/app/assets/logo_app.png',
                  height: 300,
                ),
                const SizedBox(height: 30.0),
                Container(
                  margin: const EdgeInsets.all(16.0), // Adiciona espaçamento externo
                  child: Material(
                    elevation: 5, // Sombra
                    borderRadius: BorderRadius.circular(15.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0), // Adiciona espaçamento interno
                      child: Column(
                        children: [
                          const SizedBox(height: 20.0),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email ou usuário antigo',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              enabled: !_isLoading,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                border: const OutlineInputBorder(),
                                prefixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  child: Icon(
                                    _isPasswordVisible
                                        ? Icons.lock_open
                                        : Icons.lock,
                                  ),
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                              obscureText: !_isPasswordVisible,
                              enabled: !_isLoading,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF11E333),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Entrar',
                                    style: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                ),
                          const SizedBox(height: 10.0),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CreateUserPopup(); // Mostra o popup de criação de usuário
                                },
                              );
                            },
                            child: const Text(
                              'Cadastre-se',
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 56.0,
          alignment: Alignment.center,
          child: const SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12),
                Text(
                  'Criador: Emiliano Calado',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Contato: emiliano.jgac@gmail.com',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
