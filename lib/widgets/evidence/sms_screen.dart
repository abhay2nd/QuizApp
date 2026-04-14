import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../models/models.dart';

class SmsScreen extends StatelessWidget {
  final Evidence evidence;

  const SmsScreen({super.key, required this.evidence});

  @override
  Widget build(BuildContext context) {
    final isHighContrast = context.watch<GameProvider>().isHighContrast;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isHighContrast ? const Color(0xFF121212) : Colors.white, // Dark mode background or white
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isHighContrast ? Colors.grey.shade800 : Colors.grey.shade300, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Simulated App Bar
          Container(
            color: isHighContrast ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: isHighContrast ? Colors.white : Colors.black87),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  child: const Icon(Icons.person, color: Colors.blueAccent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        evidence.title,
                        style: TextStyle(
                          color: isHighContrast ? Colors.white : Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'via SMS',
                        style: TextStyle(
                          color: isHighContrast ? Colors.grey.shade400 : Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.call, color: isHighContrast ? Colors.white : Colors.black87),
                const SizedBox(width: 16),
                Icon(Icons.more_vert, color: isHighContrast ? Colors.white : Colors.black87),
              ],
            ),
          ),
          
          // Chat Body
          Container(
            padding: const EdgeInsets.all(16),
            color: isHighContrast ? const Color(0xFF121212) : Colors.white,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Today 10:42 AM',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(height: 16),
                // Received Message Bubble
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 20, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isHighContrast ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                        child: Text(
                          evidence.description,
                          style: TextStyle(
                            color: isHighContrast ? Colors.white : Colors.black87,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Padding on right for realistic look
                  ],
                ),
              ],
            ),
          ),
          
          // Reply Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: isHighContrast ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
            child: Row(
              children: [
                const Icon(Icons.add_circle_outline, color: Colors.grey),
                const SizedBox(width: 12),
                const Icon(Icons.camera_alt_outlined, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isHighContrast ? const Color(0xFF2C2C2C) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: isHighContrast ? null : Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Text('Text message', style: TextStyle(color: Colors.grey)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
