import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedLanguage = 'english'; // Default

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name first.')),
      );
      return;
    }

    // Initialize the profile with user inputs
    context.read<GameProvider>().initializeProfile(
      _nameController.text.trim(), 
      _selectedLanguage
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHighContrast = context.watch<GameProvider>().isHighContrast;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: isHighContrast ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: isHighContrast ? Colors.black.withOpacity(0.5) : Colors.blueAccent.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
            border: isHighContrast ? Border.all(color: Colors.grey[800]!) : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Icon(Icons.shield, size: 64, color: isHighContrast ? Colors.white : const Color(0xFF6366F1)),
              const SizedBox(height: 16),
              Text(
                'Welcome Detective',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: isHighContrast ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please set up your profile to begin your investigation.',
                textAlign: TextAlign.center,
                style: TextStyle(color: isHighContrast ? Colors.grey[400] : Colors.black54, fontSize: 16),
              ),
              const SizedBox(height: 32),

              // Name Input
              TextField(
                controller: _nameController,
                style: TextStyle(color: isHighContrast ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  labelStyle: TextStyle(color: isHighContrast ? Colors.grey[400] : Colors.grey[600]),
                  prefixIcon: Icon(Icons.person, color: isHighContrast ? Colors.white : const Color(0xFF6366F1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(color: isHighContrast ? Colors.grey[700]! : Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(color: isHighContrast ? Colors.grey[700]! : Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(color: isHighContrast ? Colors.white : const Color(0xFF6366F1), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Language Selection
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Language',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isHighContrast ? Colors.white : Colors.black87),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildLangButton('English', 'english', _selectedLanguage == 'english', isHighContrast),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildLangButton('हिन्दी (Hindi)', 'hindi', _selectedLanguage == 'hindi', isHighContrast),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Begin Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isHighContrast ? Colors.white : const Color(0xFF6366F1),
                    foregroundColor: isHighContrast ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 4,
                  ),
                  onPressed: _submit,
                  child: const Text('Start Investigation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLangButton(String label, String value, bool isSelected, bool isHighContrast) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected 
            ? (isHighContrast ? Colors.white.withOpacity(0.2) : const Color(0xFF6366F1).withOpacity(0.1)) 
            : Colors.transparent,
          border: Border.all(
            color: isSelected 
              ? (isHighContrast ? Colors.white : const Color(0xFF6366F1)) 
              : (isHighContrast ? Colors.grey.shade700 : Colors.grey.shade300),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
              ? (isHighContrast ? Colors.white : const Color(0xFF6366F1)) 
              : (isHighContrast ? Colors.grey[400] : Colors.black54),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
