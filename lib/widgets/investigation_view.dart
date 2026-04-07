import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/models.dart';
import 'evidence/sms_screen.dart';
import 'evidence/call_screen.dart';
import 'evidence/document_screen.dart';
import 'character_guide.dart';

class InvestigationView extends StatefulWidget {
  const InvestigationView({super.key});

  @override
  State<InvestigationView> createState() => _InvestigationViewState();
}

class _InvestigationViewState extends State<InvestigationView> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _narrativeKey = GlobalKey();
  final GlobalKey _evidenceKey = GlobalKey();
  final GlobalKey _questionKey = GlobalKey();
  StoryStep? _currentStep;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final game = context.watch<GameProvider>();
    if (_currentStep != game.currentStep) {
      _currentStep = game.currentStep;
    }
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

    List<SpeakItem> speakItems = [];
    speakItems.add(SpeakItem(text: step.narrative, targetKey: _narrativeKey));
    if (step.evidence != null) {
      speakItems.add(SpeakItem(text: step.evidence!.description, targetKey: _evidenceKey));
    }
    speakItems.add(SpeakItem(text: step.question.questionText, targetKey: _questionKey));

    return Container(
      color: Colors.transparent, // Let game screen gradient show through
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 200.0), // Padding below content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Detective narrative
                Container(
                  key: _narrativeKey,
                  child: _buildChatBubble(step.narrative, isSetup: true),
                ),
                const SizedBox(height: 24),
                
                // Evidence Builder
                if (step.evidence != null) ...[
                  Container(
                    key: _evidenceKey,
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    child: _buildEvidenceWidget(step.evidence!),
                  ),
                  const SizedBox(height: 32),
                ],
                
                // Question
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        key: _questionKey,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF4F46E5)], // Vibrant modern indigo
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.3), // Vibrant glow
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Text(
                      step.question.questionText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 2)],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Options
            ...List.generate(step.question.options.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ) // Soft floating effect
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1E293B),
                      side: BorderSide(color: Colors.blueAccent.withOpacity(0.2), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      alignment: Alignment.centerLeft,
                    ),
                    onPressed: () {
                      context.read<GameProvider>().answerQuestion(index);
                    },
                    child: Text(
                      step.question.options[index],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      Positioned(
        bottom: 0,
        left: -20, // Give her a slight offset in the bottom left
        child: IgnorePointer(
          child: CharacterGuide(items: speakItems),
        ),
      ),
    ]));
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
        color: isSetup ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomRight: isSetup ? const Radius.circular(16) : Radius.zero,
          bottomLeft: isSetup ? Radius.zero : const Radius.circular(16),
        ),
        border: Border.all(
          color: isSetup ? Colors.blueAccent.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.blueGrey.shade900, height: 1.4),
      ),
    );
  }
}
