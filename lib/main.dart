import 'package:flutter/material.dart';
import 'package:food_app/composition_root.dart';
import 'package:food_app/ui/pages/auth/auth_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  CompositionRoot.configure();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Space',
      theme: ThemeData(
        accentColor: Color.fromARGB(255, 251, 176, 59),
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
      ),
      home: CompositionRoot.composeAuthUi(),
    );
  }
}
