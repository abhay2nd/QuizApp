import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/case_selection_view.dart';
import '../widgets/investigation_view.dart';
import '../widgets/feedback_view.dart';
import '../widgets/case_complete_view.dart';
import '../widgets/welcome_view.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'FRAUD DETECTIVE',
          style: TextStyle(
            letterSpacing: 3, 
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E3A8A), // Dark blue text
            shadows: [Shadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.9), 
                Colors.white.withOpacity(0.4)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9), Color(0xFFE2E8F0)], // Soft modern slates/white
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Consumer<GameProvider>(
          builder: (context, game, child) {
            Widget currentView;
            switch (game.state) {
              case GameState.welcome:
                currentView = const WelcomeView(key: ValueKey('welcome'));
                break;
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
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.08),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: SafeArea(child: currentView),
            );
          },
        ),
      ),
    );
  }
}
