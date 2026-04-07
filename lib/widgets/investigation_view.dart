import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/models.dart';
import 'evidence/sms_screen.dart';
import 'evidence/call_screen.dart';
import 'evidence/document_screen.dart';

class InvestigationView extends StatefulWidget {
  const InvestigationView({super.key});

  @override
  State<InvestigationView> createState() => _InvestigationViewState();
}

class _InvestigationViewState extends State<InvestigationView> {
  final ScrollController _scrollController = ScrollController();
  StoryStep? _currentStep;

  @override
  void initState() {
    super.initState();
    _scheduleAutoScroll();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final game = context.watch<GameProvider>();
    if (_currentStep != game.currentStep) {
      _currentStep = game.currentStep;
      _scheduleAutoScroll();
    }
  }

  void _scheduleAutoScroll() {
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentStep == null) return const SizedBox.shrink();
    final step = _currentStep!;

    return Container(
      color: const Color(0xFF0F172A),
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Detective narrative
            _buildChatBubble(step.narrative, isSetup: true),
            const SizedBox(height: 24),
            
            // Evidence Builder
            if (step.evidence != null) ...[
              Container(
                width: double.infinity,
                alignment: Alignment.topCenter,
                child: _buildEvidenceWidget(step.evidence!),
              ),
              const SizedBox(height: 32),
            ],
            
            // Question text
            Row(
              children: [
                const Icon(Icons.volume_up, color: Colors.blueAccent, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    step.question.questionText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Options
            ...List.generate(step.question.options.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.withOpacity(0.1),
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.blueAccent.withOpacity(0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  onPressed: () {
                    context.read<GameProvider>().answerQuestion(index);
                  },
                  child: Text(
                    step.question.options[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenceWidget(Evidence evidence) {
    switch (evidence.type) {
      case 'sms':
        return SmsScreen(evidence: evidence);
      case 'call_transcript':
        return CallScreen(evidence: evidence);
      case 'image':
      case 'document':
        return DocumentScreen(evidence: evidence);
      default:
        return DocumentScreen(evidence: evidence); // Fallback
    }
  }

  Widget _buildChatBubble(String text, {required bool isSetup}) {
    return Container(
      decoration: BoxDecoration(
        color: isSetup ? Colors.blue.shade900.withOpacity(0.3) : Colors.grey.shade800,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomRight: isSetup ? const Radius.circular(16) : Radius.zero,
          bottomLeft: isSetup ? Radius.zero : const Radius.circular(16),
        ),
        border: Border.all(
          color: isSetup ? Colors.blueAccent.withOpacity(0.3) : Colors.transparent,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, color: Colors.white, height: 1.4),
      ),
    );
  }
}
