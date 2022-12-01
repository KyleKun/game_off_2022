import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:pikpik/menu.dart';
import 'pikpik_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BonfireInjector.instance.put((i) => PikPikController());
  runApp(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Titan'),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    ),
  );
}
