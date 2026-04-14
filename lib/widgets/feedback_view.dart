import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'character_guide.dart';

class FeedbackView extends StatelessWidget {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final isCorrect = game.lastAnswerCorrect;
    final step = game.currentStep;
    final isHighContrast = game.isHighContrast;

    if (step == null) return const SizedBox.shrink();

    final color = isCorrect ? Colors.green : Colors.redAccent;
    final icon = isCorrect ? Icons.check_circle_outline : Icons.error_outline;
    final title = isCorrect ? 'Good Detective Work!' : 'Critical Mistake!';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent, // Let background show
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Title and Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 40, color: color),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: color,
                      shadows: [Shadow(color: color.withOpacity(0.5), blurRadius: 10)],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // 2D Character
                      CharacterGuide(items: [
                        SpeakItem(text: step.question.explanation)
                      ]),
                      const SizedBox(height: 24),
                      
                      // 3D Styled Explanation Box
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isHighContrast ? Colors.grey[900] : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isHighContrast ? Colors.grey[800]! : color.withOpacity(0.3), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.15),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EXPLANATION:',
                              style: TextStyle(
                                color: color.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              step.question.explanation,
                              style: TextStyle(
                                fontSize: 18, 
                                color: isHighContrast ? Colors.white : const Color(0xFF1E293B), 
                                height: 1.5
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Divider(color: Colors.black12, thickness: 1),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.shield, color: Colors.orangeAccent, size: 24),
                                const SizedBox(width: 12),
                                Text(
                                  'SAFETY TIP',
                                  style: TextStyle(
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              step.question.safetyTip,
                              style: TextStyle(
                                fontSize: 16,
                                color: isHighContrast ? Colors.grey[400] : Colors.grey.shade800,
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Continue Button
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        context.read<GameProvider>().nextStep();
                      },
                      child: const Text('CONTINUE INVESTIGATION', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
