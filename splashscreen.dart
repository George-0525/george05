import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:george/view/auth/login_.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      ),
    );

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    super.dispose();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 215, 223, 233),
              Color.fromARGB(255, 215, 223, 233)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: EdgeInsets.only(left: 0),
              child: Image.asset(
                "image/healthgaurdd.png",
                width: 300,
                height: 300,
              ),
            ),
            SizedBox(height: 0.1),
            Text(
              "Healthgaurd",
              style: TextStyle(
                fontSize: 30,
                color: const Color.fromARGB(255, 3, 66, 126),
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 0),
              child: const CircularProgressIndicator(
                color: Color.fromARGB(255, 3, 66, 126),
              ),
            )
          ],
        ),
      ),
    );
  }
}
