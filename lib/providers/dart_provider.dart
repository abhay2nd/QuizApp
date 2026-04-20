import 'package:flutter/material.dart';
import '../models/dart_models.dart';
import '../services/tts_service.dart';

class DartGameProvider extends ChangeNotifier {
  int dartsLeft = 3;
  int score = 0;
  int currentLevel = 1;

  bool _isQuizMode = false;
  bool get isQuizMode => _isQuizMode;

  DartQuizQuestion? _currentQuestion;
  DartQuizQuestion? get currentQuestion => _currentQuestion;

  bool _lastAnswerCorrect = false;
  bool get lastAnswerCorrect => _lastAnswerCorrect;
  
  bool _showFeedback = false;
  bool get showFeedback => _showFeedback;

  late List<DartQuizQuestion> _questionPool;

  DartGameProvider() {
    _questionPool = List.from(sampleDartQuestions);
    _questionPool.shuffle();
  }

  void throwDart(int points) {
    if (dartsLeft > 0 && !_isQuizMode) {
      dartsLeft--;
      score += points;
      notifyListeners();

      if (dartsLeft == 0) {
        // Delay slightly before showing quiz
        Future.delayed(const Duration(milliseconds: 1000), () {
          startQuiz();
        });
      }
    }
  }

  void startQuiz() {
    if (_questionPool.isEmpty) {
      _questionPool = List.from(sampleDartQuestions);
      _questionPool.shuffle();
    }
    _currentQuestion = _questionPool.removeLast();
    _isQuizMode = true;
    _showFeedback = false;
    notifyListeners();
  }

  void answerQuestion(int selectedIndex) {
    if (_currentQuestion == null) return;
    
    _lastAnswerCorrect = (selectedIndex == _currentQuestion!.correctOptionIndex);
    _showFeedback = true;
    notifyListeners();
    
    // Auto advance or wait for user action
  }

  void dismissFeedback() {
    TTSService().stop(); // Stop any explanation being read
    if (_lastAnswerCorrect) {
      // Reward and move to next round
      dartsLeft = 3;
      currentLevel++;
      _isQuizMode = false;
      _showFeedback = false;
    } else {
      // Loop: generate another question
      startQuiz();
    }
    notifyListeners();
  }
}
