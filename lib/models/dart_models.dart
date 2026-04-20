class DartQuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  DartQuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
}

// Sample finance questions
final List<DartQuizQuestion> sampleDartQuestions = [
  DartQuizQuestion(
    questionText: 'What is the safest way to store your emergency fund?',
    options: ['Under the mattress', 'A high-yield savings account', 'In cryptocurrency', 'In a checking account'],
    correctOptionIndex: 1,
    explanation: 'A high-yield savings account gives you quick access to your money while earning safe interest.',
  ),
  DartQuizQuestion(
    questionText: 'If you receive an SMS saying your bank account is suspended and providing a link to verify your identity, you should:',
    options: ['Click the link immediately', 'Reply to the SMS with your details', 'Ignore it and call your bank\'s official number', 'Forward it to your friends'],
    correctOptionIndex: 2,
    explanation: 'Banks never ask you to verify details via SMS links. Always contact the bank directly using their official number.',
  ),
  DartQuizQuestion(
    questionText: 'What does "phishing" mean in cybersecurity?',
    options: ['A sport involving water', 'A secure way to transfer money', 'Deceptively getting users to reveal personal information', 'A type of safe investment'],
    correctOptionIndex: 2,
    explanation: 'Phishing is a scam where criminals send fraudulent communications that appear to come from a reputable source.',
  ),
  DartQuizQuestion(
    questionText: 'Why is diversification important in investing?',
    options: ['It guarantees huge profits', 'It ensures zero taxes', 'It puts all your money in the best stock', 'It reduces risk by spreading investments'],
    correctOptionIndex: 3,
    explanation: 'Diversification spreads your investments across different assets to reduce overall risk.',
  ),
];
