import 'package:flutter/material.dart';
import '../../models/models.dart';

class CallScreen extends StatelessWidget {
  final Evidence evidence;

  const CallScreen({super.key, required this.evidence});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A), // Black background for call
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade800, width: 2),
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
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '00:45',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
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
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.record_voice_over, color: Colors.greenAccent, size: 16),
                    SizedBox(width: 8),
                    Text('Live Transcript', style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  evidence.description,
                  style: const TextStyle(
                    color: Colors.white,
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
                _buildActionButton(Icons.mic_off, 'Mute'),
                _buildActionButton(Icons.dialpad, 'Keypad'),
                _buildActionButton(Icons.volume_up, 'Speaker'),
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

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
