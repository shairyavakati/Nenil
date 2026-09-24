import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';

class RegionalQuizGameScreen extends StatefulWidget {
  const RegionalQuizGameScreen({super.key});

  @override
  State<RegionalQuizGameScreen> createState() => _RegionalQuizGameScreenState();
}

class _RegionalQuizGameScreenState extends State<RegionalQuizGameScreen> {
  final TTSService _ttsService = TTSService();
  String _selectedRegion = 'South';
  int _currentQuestionIndex = 0;
  String? _selectedOption;
  bool _isAnswerCorrect = false;

  final List<String> _regions = ['South', 'North', 'East', 'West'];

  // Dummy quiz data
  final Map<String, List<Map<String, dynamic>>> _quizData = {
    'South': [
      {
        'question': 'Which of these is a famous classical dance from Tamil Nadu?',
        'options': ['Kathak', 'Bharatanatyam', 'Odissi', 'Kuchipudi'],
        'answer': 'Bharatanatyam',
      },
      {
        'question': 'Which festival is widely celebrated as the harvest festival in Kerala?',
        'options': ['Pongal', 'Onam', 'Bihu', 'Makar Sankranti'],
        'answer': 'Onam',
      }
    ],
    'North': [
      {
        'question': 'Which monument is one of the Seven Wonders of the World located in Agra?',
        'options': ['Red Fort', 'Qutub Minar', 'Taj Mahal', 'India Gate'],
        'answer': 'Taj Mahal',
      }
    ],
    'East': [
      {
        'question': 'Which sweet dish is very popular in Bengal, made from chhena?',
        'options': ['Rasgulla', 'Jalebi', 'Ladoo', 'Barfi'],
        'answer': 'Rasgulla',
      }
    ],
    'West': [
      {
        'question': 'Which colorful dance is performed during Navratri in Gujarat?',
        'options': ['Bhangra', 'Ghoomar', 'Garba', 'Lavani'],
        'answer': 'Garba',
      }
    ],
  };

  void _speakQuestionAndOptions() {
    final qData = _quizData[_selectedRegion]![_currentQuestionIndex];
    String textToSpeak = "${qData['question']}. The options are: ";
    for (String opt in qData['options']) {
      textToSpeak += "$opt, ";
    }
    _ttsService.speak(textToSpeak);
  }

  void _onOptionSelected(String option) {
    if (_selectedOption != null) return; // Prevent multiple selections

    final qData = _quizData[_selectedRegion]![_currentQuestionIndex];
    setState(() {
      _selectedOption = option;
      _isAnswerCorrect = (option == qData['answer']);
    });

    if (_isAnswerCorrect) {
      _ttsService.speak("Wonderful! $option is the correct answer.");
    } else {
      _ttsService.speak("Good try, but the correct answer is ${qData['answer']}.");
    }

    // Move to next question or show completion after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        if (_currentQuestionIndex < _quizData[_selectedRegion]!.length - 1) {
          setState(() {
            _currentQuestionIndex++;
            _selectedOption = null;
            _isAnswerCorrect = false;
          });
          _speakQuestionAndOptions();
        } else {
          _ttsService.speak("You have completed the quiz for $_selectedRegion. Great job!");
          _showCompletionDialog();
        }
      }
    });
  }
  
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Quiz Complete! 🌟',
          style: GoogleFonts.newsreader(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'You answered all questions for $_selectedRegion.',
          style: GoogleFonts.outfit(
            fontSize: 18,
            color: AppColors.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentQuestionIndex = 0;
                _selectedOption = null;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Play Again',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'Back to Games',
              style: GoogleFonts.outfit(fontSize: 16, color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = _quizData[_selectedRegion]![_currentQuestionIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cultural Quiz',
          style: GoogleFonts.newsreader(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 26,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up, color: AppColors.primary),
            onPressed: _speakQuestionAndOptions,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Region Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: _regions.map((region) {
                  bool isSelected = _selectedRegion == region;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        region,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surfaceContainerLowest,
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() {
                            _selectedRegion = region;
                            _currentQuestionIndex = 0;
                            _selectedOption = null;
                          });
                          _speakQuestionAndOptions();
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Question Card
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.outlineVariant, width: 1),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.help_outline, size: 48, color: AppColors.tertiary),
                          const SizedBox(height: 16),
                          Text(
                            currentQ['question'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.newsreader(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Options
                    ...List.generate(currentQ['options'].length, (index) {
                      String option = currentQ['options'][index];
                      bool isSelected = _selectedOption == option;
                      bool isCorrect = option == currentQ['answer'];
                      
                      Color cardColor = AppColors.surfaceContainerLowest;
                      Color borderColor = AppColors.outlineVariant;
                      IconData? icon;
                      Color iconColor = AppColors.primary;
                      
                      if (_selectedOption != null) {
                        if (isCorrect) {
                          cardColor = AppColors.primaryFixed;
                          borderColor = AppColors.primary;
                          icon = Icons.check_circle;
                        } else if (isSelected) {
                          cardColor = AppColors.surfaceContainerHigh;
                          borderColor = AppColors.outline;
                          icon = Icons.cancel;
                          iconColor = AppColors.secondary;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Material(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () => _onOptionSelected(option),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: borderColor, width: isSelected || (isCorrect && _selectedOption != null) ? 2 : 1),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                  ),
                                  if (icon != null)
                                    Icon(icon, color: iconColor, size: 24),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
