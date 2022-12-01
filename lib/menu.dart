import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:pikpik/fancy_button.dart';
import 'package:pikpik/sounds_manager.dart';

import 'my_game.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: FlameSplashScreen(
          theme: FlameSplashTheme.dark,
          controller: FlameSplashController(
            waitDuration: const Duration(seconds: 1),
            fadeOutDuration: const Duration(seconds: 3),
          ),
          onFinish: (context) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Material(child: MainMenu()),
            ),
          ),
        ),
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  void initState() {
    super.initState();
    SoundsManager.playMenu();
  }

  @override
  void dispose() {
    SoundsManager.stopBgm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/menu.png',
          fit: BoxFit.cover,
        ),
        Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          const SizedBox(height: 1.0),
          const Text('PikPik', style: TextStyle(fontSize: 75)),
          FancyButton(
            size: 64.0,
            color: Colors.green,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyGame()),
              );
            },
            child: const Text(
              'PLAY',
              style: TextStyle(fontSize: 42.0, color: Colors.white),
            ),
          )
        ]),
      ],
    );
  }
}
