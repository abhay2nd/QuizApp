import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../models/models.dart';

class DocumentScreen extends StatelessWidget {
  final Evidence evidence;

  const DocumentScreen({super.key, required this.evidence});

  @override
  Widget build(BuildContext context) {
    final isHighContrast = context.watch<GameProvider>().isHighContrast;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isHighContrast ? const Color(0xFF1E1E1E) : Colors.grey.shade200, // PDF Viewer background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isHighContrast ? Colors.grey.shade700 : Colors.grey.shade400, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Toolbar
          Container(
            color: isHighContrast ? const Color(0xFF2C2C2C) : Colors.grey.shade300,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    evidence.title,
                    style: TextStyle(color: isHighContrast ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.file_download, color: isHighContrast ? Colors.white : Colors.black87),
              ],
            ),
          ),
          
          // Document Content
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isHighContrast ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Icon(Icons.account_balance, size: 48, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Text(
                  evidence.description,
                  style: TextStyle(
                    color: isHighContrast ? Colors.white : Colors.black87,
                    fontSize: 16,
                    height: 1.6,
                    fontFamily: 'serif',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                const Divider(),
                const Text(
                  'CONFIDENTIAL & SENSITIVE',
                  style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
