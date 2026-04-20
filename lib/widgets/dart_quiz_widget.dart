import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/dart_provider.dart';
import '../providers/game_provider.dart';
import 'character_guide.dart';

class DartQuizWidget extends StatelessWidget {
  const DartQuizWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<DartGameProvider>();
    final isHighContrast = context.select((GameProvider g) => g.isHighContrast);
    final question = game.currentQuestion;

    if (question == null) return const SizedBox();

    return Stack(
      children: [
        // Main Quiz Body
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 40.0, bottom: 20.0),
            child: Column(
              children: [
                // Full-width Question Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isHighContrast ? Colors.grey[900] : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 5))],
                  ),
                  child: Text(
                    question.questionText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                      color: isHighContrast ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Options or Feedback
                if (!game.showFeedback)
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: question.options.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              padding: const EdgeInsets.all(20),
                              backgroundColor: isHighContrast ? Colors.grey[800] : Colors.white,
                              foregroundColor: isHighContrast ? Colors.white : Colors.indigo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.indigo.withOpacity(0.2)),
                              ),
                            ),
                            onPressed: () {
                               HapticFeedback.lightImpact();
                               context.read<DartGameProvider>().answerQuestion(index);
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      String.fromCharCode(65 + index),
                                      style: TextStyle(fontWeight: FontWeight.bold, color: isHighContrast ? Colors.white : Colors.indigo),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    question.options[index],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                          child: Icon(
                            game.lastAnswerCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                            color: game.lastAnswerCorrect ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
                            size: 100,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          game.lastAnswerCorrect ? 'Excellent! +3 Darts' : 'Not Quite Right...',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: game.lastAnswerCorrect ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (!game.lastAnswerCorrect)
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: isHighContrast ? Colors.grey[850] : Colors.red.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.lightbulb, color: Colors.amber, size: 32),
                                const SizedBox(height: 12),
                                Text(
                                  question.explanation,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    height: 1.5,
                                    color: isHighContrast ? Colors.white : Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 48),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: game.lastAnswerCorrect ? const Color(0xFF22C55E) : Colors.indigo,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 5,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              context.read<DartGameProvider>().dismissFeedback();
                            },
                            child: Text(
                              game.lastAnswerCorrect ? 'NEXT ROUND' : 'TRY ANOTHER QUESTION', 
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ), // Closes SingleChildScrollView
                ) // Closes Expanded
              ],
            ),
          ),
        ),

        // Revert: Full Assistant embedded floating in the bottom-left screen space
        Positioned(
          bottom: 20,
          left: 5,
          child: SizedBox(
            width: 140, // Ensure enough width
            height: 140,
            child: CharacterGuide(
              items: game.showFeedback 
                  ? [SpeakItem(text: question.explanation)] 
                  : [SpeakItem(text: '${question.questionText}... Options are: ${question.options.join(', ')}')],
            ),
          ),
        ),
      ],
    );
  }
}
