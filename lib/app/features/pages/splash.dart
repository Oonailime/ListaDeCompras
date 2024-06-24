import 'package:lista_de_compras/app/features/pages/main_list.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 100000000000000000), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const MainListView()));
    });

    return Scaffold(
      body: InkWell(
        child: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff11ee62), Color(0xffd2f8d6)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.0, 1.0],
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'lib/app/assets/logo_app.png',
              width: 310,
              height: 310,
            ),
          ),
        ]),
        onTap: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainListView())),
      ),
    );
  }
}
