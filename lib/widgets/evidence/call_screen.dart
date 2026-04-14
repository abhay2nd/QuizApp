import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../models/models.dart';

class CallScreen extends StatelessWidget {
  final Evidence evidence;

  const CallScreen({super.key, required this.evidence});

  @override
  Widget build(BuildContext context) {
    final isHighContrast = context.watch<GameProvider>().isHighContrast;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isHighContrast ? const Color(0xFF0A0A0A) : Colors.grey.shade100, // Black background for call
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isHighContrast ? Colors.grey.shade800 : Colors.grey.shade300, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Call Info
          Center(
            child: Column(
              children: [
                Text(
                  evidence.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: isHighContrast ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '00:45',
                  style: TextStyle(
                    fontSize: 16,
                    color: isHighContrast ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Avatar
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent.withOpacity(0.2),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 2),
            ),
            child: const Icon(Icons.person, size: 80, color: Colors.blueAccent),
          ),
          
          const SizedBox(height: 32),
          
          // Transcript (The Evidence itself)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isHighContrast ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isHighContrast ? null : [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.record_voice_over, color: isHighContrast ? Colors.greenAccent : Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Text('Live Transcript', style: TextStyle(color: isHighContrast ? Colors.greenAccent : Colors.green, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  evidence.description,
                  style: TextStyle(
                    color: isHighContrast ? Colors.white : Colors.black87,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Call Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(Icons.mic_off, 'Mute', isHighContrast),
                _buildActionButton(Icons.dialpad, 'Keypad', isHighContrast),
                _buildActionButton(Icons.volume_up, 'Speaker', isHighContrast),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // End Call Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: const Icon(Icons.call_end, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, bool isHighContrast) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isHighContrast ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
          ),
          child: Icon(icon, color: isHighContrast ? Colors.white : Colors.black87, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: isHighContrast ? Colors.white70 : Colors.black54, fontSize: 12)),
      ],
    );
  }
}
