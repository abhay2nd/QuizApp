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
  bool _isExpanded = false; // Add expanded state
  late AnimationController _wobbleController;

  @override
  void initState() {
    super.initState();
    _wobbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // Remove auto-start speaking
    // _startSpeakingSequence();
  }

  @override
  void didUpdateWidget(CharacterGuide oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If text changes, stop speaking but keep expanded state? Or collapse?
    // Let's collapse if items changed so it requires another tap, or just reset.
    if (oldWidget.items.length != widget.items.length || 
       (oldWidget.items.isNotEmpty && widget.items.isNotEmpty && oldWidget.items.first.text != widget.items.first.text)) {
      if (mounted) {
        setState(() {
          _isExpanded = false;
          _isSpeaking = false;
        });
      }
      TTSService().stop();
      _wobbleController.stop();
      _wobbleController.value = 0;
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
        _isExpanded = true;
        _isSpeaking = true;
      });
      _wobbleController.repeat(reverse: true);
    }

    for (var item in widget.items) {
      if (!mounted || !_isSpeaking) break; // Check if cancelled
      if (item.text.trim().isEmpty) continue;

      if (item.targetKey != null && item.targetKey!.currentContext != null) {
        Scrollable.ensureVisible(
          item.targetKey!.currentContext!, 
          duration: const Duration(milliseconds: 600), 
          curve: Curves.easeInOut,
          alignment: 0.1, 
        );
      }

      await TTSService().speak(item.text);
      await Future.delayed(const Duration(seconds: 1));
    }

    if (mounted) {
      setState(() {
        _isSpeaking = false;
      });
      _wobbleController.stop();
      _wobbleController.value = 0; 
      if (widget.onSpeakComplete != null) {
        widget.onSpeakComplete!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: _isExpanded ? 280 : 60,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          AnimatedOpacity(
            opacity: _isExpanded ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              width: _isExpanded ? 160 : 160,
              height: _isExpanded ? 280 : 60,
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
            ),
          ),
        if (!_isExpanded)
          Positioned(
            bottom: 20,
            left: 40,
            child: FloatingActionButton(
              onPressed: () {
                _startSpeakingSequence();
              },
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              child: const Icon(Icons.record_voice_over),
            ),
          ),
        if (_isExpanded)
          Positioned(
            bottom: 10,
            left: 60,
            child: IconButton(
              icon: const Icon(Icons.stop_circle, color: Colors.redAccent, size: 36),
              onPressed: () {
                TTSService().stop();
                _wobbleController.stop();
                _wobbleController.value = 0;
                if (mounted) {
                  setState(() {
                    _isSpeaking = false;
                    _isExpanded = false;
                  });
                }
              },
            ),
          )
      ],
      ),
    );
  }
}
