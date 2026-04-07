import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/tts_service.dart';

class SpeakItem {
  final String text;
  final GlobalKey? targetKey;
  
  SpeakItem({required this.text, this.targetKey});
}

class CharacterGuide extends StatefulWidget {
  final List<SpeakItem> items;
  final VoidCallback? onSpeakComplete;

  const CharacterGuide({
    super.key,
    required this.items,
    this.onSpeakComplete,
  });

  @override
  State<CharacterGuide> createState() => _CharacterGuideState();
}

class _CharacterGuideState extends State<CharacterGuide> with SingleTickerProviderStateMixin {
  bool _isSpeaking = false;
  late AnimationController _wobbleController;

  @override
  void initState() {
    super.initState();
    _wobbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _startSpeakingSequence();
  }

  @override
  void didUpdateWidget(CharacterGuide oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rough check if items changed. Alternatively, we could generate an ID for the step.
    if (oldWidget.items.length != widget.items.length || 
       (oldWidget.items.isNotEmpty && widget.items.isNotEmpty && oldWidget.items.first.text != widget.items.first.text)) {
      _startSpeakingSequence();
    }
  }

  @override
  void dispose() {
    _wobbleController.dispose();
    super.dispose();
  }

  Future<void> _startSpeakingSequence() async {
    if (widget.items.isEmpty) return;

    if (mounted) {
      setState(() {
        _isSpeaking = true;
      });
      _wobbleController.repeat(reverse: true);
    }

    for (var item in widget.items) {
      if (item.text.trim().isEmpty) continue;

      // Scroll to the targeted section
      if (item.targetKey != null && item.targetKey!.currentContext != null) {
        Scrollable.ensureVisible(
          item.targetKey!.currentContext!, 
          duration: const Duration(milliseconds: 600), 
          curve: Curves.easeInOut,
          alignment: 0.1, // Aligns to near top
        );
      }

      // The speak method will inherently await completion because of awaitSpeakCompletion(true) in tts_service
      await TTSService().speak(item.text);

      // We wait proportionally based on text length since some devices might not trigger the completion correctly.
      // With speed rate at 0.7, 18 characters/sec is a good rule of thumb.
     // final estimatedSeconds = (item.text.length / 18).ceil() + 1;
      await Future.delayed(Duration(seconds: 1));
    }

    if (mounted) {
      setState(() {
        _isSpeaking = false;
      });
      _wobbleController.stop();
      _wobbleController.value = 0; // reset
      if (widget.onSpeakComplete != null) {
        widget.onSpeakComplete!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // When speaking she is larger and positioned up. When quiet, she sinks down.
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      width: _isSpeaking ? 160 : 0,
      height: _isSpeaking ? 280 : 0,
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
        animation: _wobbleController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _isSpeaking ? math.sin(_wobbleController.value * math.pi * 2) * 0.05 : 0.0,
            child: child,
          );
        },
        child: Image.asset(
          'assets/images/sherlock_girl_transparent.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/sherlock_girl.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
