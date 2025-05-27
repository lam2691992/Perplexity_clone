import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perplexity/theme/colors.dart';
import 'package:perplexity/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thua Gia Cát Lượng mỗi bộ râu',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.submitButton),
        textTheme: GoogleFonts.inderTextTheme(
          ThemeData.dark().textTheme.copyWith(
              bodyMedium: const TextStyle(fontSize: 15, color: Colors.white)),
        ),
      ),
      home: const HomePage(
      ),
    );
  }
}
