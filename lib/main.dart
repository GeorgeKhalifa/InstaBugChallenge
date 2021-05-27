import 'package:flutter/material.dart';
import 'package:last_trial/screens/home.dart';

    void main() => runApp(MyApp());

    class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Movie List',
          home: HomePage(),
        );
      }
    }

   