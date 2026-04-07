import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/case_data.dart' as english_data;
import '../data/case_data_hindi.dart' as hindi_data;
import '../services/tts_service.dart';

enum GameState {
  welcome,
  caseSelection,
  investigation,
  feedback,
  caseComplete,
}

class GameProvider extends ChangeNotifier {
  GameState _state = GameState.welcome; // Default state is welcome
  Case? _currentCase;
  int _currentStepIndex = 0;
  bool _lastAnswerCorrect = false;
  int _score = 0;
  
  // Profile
  String? userName;
  String language = 'english';
  List<Case> availableCases = [];

  GameState get state => _state;
  Case? get currentCase => _currentCase;
  int get currentStepIndex => _currentStepIndex;
  bool get lastAnswerCorrect => _lastAnswerCorrect;
  int get score => _score;
  int get maxScore => _currentCase?.steps.length ?? 0;

  StoryStep? get currentStep {
    if (_currentCase == null) return null;
    if (_currentStepIndex >= _currentCase!.steps.length) return null;
    return _currentCase!.steps[_currentStepIndex];
  }

  void _triggerTTS() {
    final step = currentStep;
    if (step != null && _state == GameState.investigation) {
      TTSService().speak("${step.narrative}. ${step.question.questionText}");
    } else {
      TTSService().stop();
    }
  }

  void initializeProfile(String name, String lang) {
    userName = name;
    language = lang;
    
    // Switch datasets & configure TTS correctly
    if (lang == 'hindi') {
      availableCases = hindi_data.allCases;
      TTSService().setLanguageConfig('hindi');
    } else {
      availableCases = english_data.allCases;
      TTSService().setLanguageConfig('english');
    }
    
    _state = GameState.caseSelection;
    notifyListeners();
  }

  void startCase(Case c) {
    _currentCase = c;
    _currentStepIndex = 0;
    _score = 0;
    _state = GameState.investigation;
    notifyListeners();
    _triggerTTS();
  }

  void answerQuestion(int selectedIndex) {
    TTSService().stop();
    if (currentStep == null) return;
    
    _lastAnswerCorrect = (selectedIndex == currentStep!.question.correctOptionIndex);
    if (_lastAnswerCorrect) {
      _score++;
    }
    
    _state = GameState.feedback;
    notifyListeners();
  }

  void nextStep() {
    if (_currentCase == null) return;

    _currentStepIndex++;
    if (_currentStepIndex >= _currentCase!.steps.length) {
      _state = GameState.caseComplete;
      TTSService().stop();
    } else {
      _state = GameState.investigation;
      _triggerTTS();
    }
    notifyListeners();
  }

  void returnToMenu() {
    TTSService().stop();
    _state = GameState.caseSelection;
    _currentCase = null;
    _currentStepIndex = 0;
    _score = 0;
    notifyListeners();
  }
}
