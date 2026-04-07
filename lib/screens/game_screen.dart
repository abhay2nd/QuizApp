import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/case_selection_view.dart';
import '../widgets/investigation_view.dart';
import '../widgets/feedback_view.dart';
import '../widgets/case_complete_view.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FRAUD DETECTIVE',
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w800),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Consumer<GameProvider>(
        builder: (context, game, child) {
          Widget currentView;
          switch (game.state) {
            case GameState.caseSelection:
              currentView = const CaseSelectionView(key: ValueKey('selection'));
              break;
            case GameState.investigation:
              currentView = const InvestigationView(key: ValueKey('investigation'));
              break;
            case GameState.feedback:
              currentView = const FeedbackView(key: ValueKey('feedback'));
              break;
            case GameState.caseComplete:
              currentView = const CaseCompleteView(key: ValueKey('complete'));
              break;
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.05),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: currentView,
          );
        },
      ),
    );
  }
}
