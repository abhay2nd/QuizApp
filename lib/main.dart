import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/game_provider.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: const FraudDetectiveApp(),
    ),
  );
}

class FraudDetectiveApp extends StatelessWidget {
  const FraudDetectiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    
    return MaterialApp(
      title: 'Fraud Detective',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: gameProvider.isHighContrast 
          ? const ColorScheme.highContrastDark() 
          : ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1), // Modern vibrant indigo
              brightness: Brightness.light,
              surface: Colors.grey[50], // Soft white background
            ),
        textTheme: GoogleFonts.interTextTheme(
          gameProvider.isHighContrast ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: gameProvider.isHighContrast ? Colors.white : Colors.black87,
        ),
      ),
      home: const GameScreen(),
    );
  }
}
