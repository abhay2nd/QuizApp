class Evidence {
  final String title;
  final String description;
  final String type; // e.g., 'sms', 'call_transcript', 'image'

  Evidence({
    required this.title,
    required this.description,
    required this.type,
  });
}

class QuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String safetyTip;

  QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.safetyTip,
  });
}

class StoryStep {
  final String narrative;
  final Evidence? evidence;
  final QuizQuestion question;

  StoryStep({
    required this.narrative,
    this.evidence,
    required this.question,
  });
}

class Case {
  final String id;
  final String title;
  final String description;
  final List<StoryStep> steps;

  Case({
    required this.id,
    required this.title,
    required this.description,
    required this.steps,
  });
}
