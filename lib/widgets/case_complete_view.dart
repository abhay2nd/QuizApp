import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class CaseCompleteView extends StatelessWidget {
  const CaseCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final score = game.score;
    final max = game.maxScore;
    final percentage = max > 0 ? (score / max) : 0;

    String rating = 'Rookie';
    Color ratingColor = Colors.orange;
    if (percentage == 1.0) {
      rating = 'Master Detective';
      ratingColor = Colors.greenAccent;
    } else if (percentage > 0.5) {
      rating = 'Senior Investigator';
      ratingColor = Colors.blueAccent;
    } else {
      rating = 'Vulnerable Target';
      ratingColor = Colors.redAccent;
    }

    return Container(
      color: const Color(0xFF0F172A),
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified_user, size: 100, color: Colors.blueAccent),
          const SizedBox(height: 32),
          const Text(
            'CASE CLOSED',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            game.currentCase?.title ?? '',
            style: const TextStyle(fontSize: 20, color: Colors.grey),
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                const Text(
                  'DETECTIVE SCORE',
                  style: TextStyle(color: Colors.grey, letterSpacing: 2),
                ),
                const SizedBox(height: 16),
                Text(
                  '$score / $max',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  rating,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ratingColor,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                context.read<GameProvider>().returnToMenu();
              },
              child: const Text('RETURN TO HEADQUARTERS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
          ),
        ],
      ),
    );
  }
}
