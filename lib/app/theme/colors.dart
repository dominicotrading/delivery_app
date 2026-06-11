import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF139863);//Color(0xFF06617a);//
const Color secondaryColor = Color(0xFF139863);//Color(0xFF06617a);//Color(0xFF1FAAD1);//Color(0xFF99CA3B);Color(0xFF06B4AA);//
const Color successColor = Color(0xFF139863);
const Color whiteColor = Color(0xFFFfFfFf);
const Color lightColor = Color(0xFFEFEFEF);
const Color darkColor = Color(0xFF242424);
const Color grayColor = Color(0xFF797979);
const Color errorColor = Color(0xFFEC3333);
const Color warningColor = Color.fromARGB(255, 160, 138, 9);

const MaterialColor primarySwatchColor = MaterialColor(
  0xFF38B6FF, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
  <int, Color>{
    50: Color.fromARGB(255, 247, 247, 232), //10%
    100: Color.fromARGB(96, 27, 27, 32), //20%
    200: Color.fromARGB(96, 27, 27, 32), //30%
    300: Color.fromARGB(96, 27, 27, 32), //40%
    400: Color.fromARGB(96, 27, 27, 32), //50%
    500: Color.fromARGB(96, 27, 27, 32), //60%
    600: Color.fromARGB(96, 27, 27, 32), //70%
    700: Color.fromARGB(96, 27, 27, 32), //80%
    800: Color.fromARGB(96, 27, 27, 32), //90%
    900: Color.fromARGB(96, 27, 27, 32), //100%
  },
);

const MaterialColor successSwatchColor = MaterialColor(
  0xFF139863,
  <int, Color>{
    50: Color.fromARGB(255, 247, 247, 232), //10%
    100: Color.fromARGB(96, 27, 27, 32), //20%
    200: Color.fromARGB(96, 27, 27, 32), //30%
    300: Color.fromARGB(96, 27, 27, 32), //40%
    400: Color.fromARGB(96, 27, 27, 32), //50%
    500: Color.fromARGB(96, 27, 27, 32), //60%
    600: Color.fromARGB(96, 27, 27, 32), //70%
    700: Color.fromARGB(96, 27, 27, 32), //80%
    800: Color.fromARGB(96, 27, 27, 32), //90%
    900: Color.fromARGB(96, 27, 27, 32), //100%
  },
);
