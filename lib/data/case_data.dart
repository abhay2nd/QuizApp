import '../models/models.dart';

final Case kycFraudCase = Case(
  id: 'case_001',
  title: 'The Urgent KYC Update',
  description: 'Investigate a suspicious',
  steps: [
    StoryStep(
      narrative: 'You are at home when your phone buzzes. You receive an SMS from a generic 6-digit number.',
      evidence: Evidence(
        title: 'VK-UCOBK', // A fake sender ID
        type: 'sms',
        description: 'Dear Customer, your UCO Bank account will be blocked today. Please update your PAN card immediately to avoid suspension. Click here: http://uco-kyc-update.net/login',
      ),
      question: QuizQuestion(
        questionText: 'What is the most obvious red flag in this SMS?',
        options: [
          'The bank is warning you before suspending the account.',
          'The URL points to "uco-kyc-update.net".',
          'It asks to update the PAN card, which is a rare requirement.',
        ],
        correctOptionIndex: 1,
        explanation: 'Banks use secure official domains like https://netbanking.bank.in. Scammers often register fake domains with hyphens or numbers, and lacking HTTPS.',
        safetyTip: 'Never click on links from unverified SMS messages. Always type your bank\'s official website URL directly into the browser.',
      ),
    ),
    StoryStep(
      narrative: 'You decide not to click the link. Good call! Ten minutes later, your phone rings. The caller ID says "Bank Support".',
      evidence: Evidence(
        title: '+91 98765 43210',
        type: 'call_transcript',
        description: 'Caller: "Hello sir, I am calling from UCO Bank head office. We noticed you haven\'t completed your KYC via the link we sent. I can help you do it over the phone so your account isn\'t blocked. I have sent a 6-digit verification code to your phone, could you please read it back to me?"',
      ),
      question: QuizQuestion(
        questionText: 'How should you respond to this caller?',
        options: [
          'Give the OTP quickly so your account isn\'t blocked.',
          'Ask them to verify their bank employee ID first.',
          'Hang up immediately. Banks never ask for OTPs over the phone.',
        ],
        correctOptionIndex: 2,
        explanation: 'The caller uses urgency ("account will be blocked") to pressure you into making a mistake. No bank official will ever ask for your OTP or PIN.',
        safetyTip: 'Remember: OTP means One Time Password. It is a secure key meant only for YOU to enter into official apps or websites, never to be shared.',
      ),
    ),
    StoryStep(
      narrative: 'You hang up. The scammer tries a different trick. They send you an official-looking document on WhatsApp claiming to be an RBI mandate.',
      evidence: Evidence(
        title: 'RBI_Mandate_Notice.pdf',
        type: 'image', // We'll represent this as a generic file attachment in UI
        description: '*** RESERVE BANK OF INDIA ***\nNotice to Customer: Failure to verify identity via AnyDesk remote support will result in a penalty of Rs. 10,000.',
      ),
      question: QuizQuestion(
        questionText: 'The document asks you to install "AnyDesk" for support. What is AnyDesk?',
        options: [
          'A mandatory banking compliance app required by the RBI.',
          'A remote desktop application that allows them to see and control your phone.',
          'A secure vault for your passwords and OTPs.',
        ],
        correctOptionIndex: 1,
        explanation: 'AnyDesk, TeamViewer, and QuickSupport are legitimate remote desktop apps that scammers abuse. If you install it, they can see your screen, read your OTPs, and empty your bank account.',
        safetyTip: 'Never install remote screen-sharing applications if instructed by an unverified caller, especially if they claim to be from a bank or tech support.',
      ),
    ),
    StoryStep(
      narrative: 'You realize the document is forged. Suddenly, another SMS arrives. It looks like a transaction alert.',
      evidence: Evidence(
        title: 'Bank Alert',
        type: 'sms',
        description: 'Txn of Rs. 50,000.00 debited from A/c XX4592. If not done by you, click http://dispute-uco.com to reverse the transaction.',
      ),
      question: QuizQuestion(
        questionText: 'You haven\'t shared your OTP or clicked any previous links. Is the money really gone?',
        options: [
          'Yes. They hacked your account using just your phone number.',
          'No. It\'s a fake alert trying to create panic so you click the new phishing link.',
          'Yes, but you can get it back if you click the dispute link fast enough.',
        ],
        correctOptionIndex: 1,
        explanation: 'This is a classic "panic hook". They send a fake debit alert. Since you didn\'t compromise your credentials earlier, your money is safe. They want you to panic and click the fake dispute link.',
        safetyTip: 'If you receive a suspicious debit alert, do not panic. Do not use the numbers or links in the SMS. Open your official banking app directly to check your balance.',
      ),
    ),
    StoryStep(
      narrative: 'You open your banking app and verify your balance is intact. You have successfully navigated a multi-layered scam attempt!',
      question: QuizQuestion(
        questionText: 'What is the best next step to take to help others?',
        options: [
          'Delete the messages and block the number locally.',
          'Report the phone number and SMS to the National Cyber Crime Reporting Portal or helpline 1930.',
          'Call the scammer back to waste their time.',
        ],
        correctOptionIndex: 1,
        explanation: 'Reporting suspicious numbers helps authorities block them at the telecom level and prevents others from falling victim to the same infrastructure.',
        safetyTip: 'You can report cyber frauds on the Cybercrime portal (cybercrime.gov.in) or call the official helpline 1930 in India.',
      ),
    ),
  ],
);

final List<Case> allCases = [kycFraudCase];
