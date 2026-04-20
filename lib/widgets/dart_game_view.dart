import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dart_provider.dart';
import '../providers/game_provider.dart';
import 'dart_board_widget.dart';
import 'dart_quiz_widget.dart';

class DartGameView extends StatelessWidget {
  const DartGameView({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide DartGameProvider specifically for this view to avoid leaking state
    return ChangeNotifierProvider(
      create: (_) => DartGameProvider(),
      child: const _DartGameViewContent(),
    );
  }
}

class _DartGameViewContent extends StatelessWidget {
  const _DartGameViewContent();

  @override
  Widget build(BuildContext context) {
    final dartGame = context.watch<DartGameProvider>();
    final isHighContrast = context.select((GameProvider g) => g.isHighContrast);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(CurvedAnimation(
                  parent: animation, curve: Curves.easeOutBack)),
              child: child,
            ),
          );
        },
        child: dartGame.isQuizMode 
            ? const DartQuizWidget(key: ValueKey('quiz'))
            : const DartBoardWidget(key: ValueKey('board')),
      ),
    );
  }
}
