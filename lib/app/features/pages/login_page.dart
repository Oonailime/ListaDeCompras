import 'package:lista_de_compras/app/features/widgets/create_user_popup.dart';
import 'package:flutter/material.dart';
import 'main_page.dart';
import '../manager/user_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    bool loggedIn = await UserManager.loginUser(username, password);

    if (loggedIn) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainListView(username: username)),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro de Login'),
            content: Text('Usuário ou senha incorretos.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('iBuy'),
        backgroundColor: Color.fromARGB(255, 88, 156, 95),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      backgroundColor: const Color(0xFFD2F8D6),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'lib/app/assets/logo_app.png',
                  height: 300,
                ),
                const SizedBox(height: 30.0),
                Container(
                  margin: EdgeInsets.all(16.0), // Adiciona espaçamento externo
                  child: Material(
                    elevation: 5, // Sombra
                    borderRadius: BorderRadius.circular(15.0),
                    child: Padding(
                      padding: EdgeInsets.all(20.0), // Adiciona espaçamento interno
                      child: Column(
                        children: [
                          SizedBox(height: 20.0),
                          Container(
                            constraints: BoxConstraints(maxWidth: 400),
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'Usuário',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            constraints: BoxConstraints(maxWidth: 400),
                            child: TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                border: OutlineInputBorder(),
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
                            ),
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF11E333),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              'Entrar',
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CreateUserPopup(); // Mostra o popup de criação de usuário
                                },
                              );
                            },
                            child: Text(
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
          child: SingleChildScrollView(
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
