import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';

class WordSearchGameScreen extends StatefulWidget {
  const WordSearchGameScreen({super.key});

  @override
  State<WordSearchGameScreen> createState() => _WordSearchGameScreenState();
}

class _WordSearchGameScreenState extends State<WordSearchGameScreen> {
  final TTSService _ttsService = TTSService();
  
  // 8x8 Grid
  final List<List<String>> _grid = [
    ['L', 'A', 'M', 'P', 'X', 'Y', 'Z', 'C'],
    ['M', 'A', 'N', 'G', 'O', 'T', 'E', 'H'],
    ['S', 'B', 'C', 'D', 'E', 'F', 'G', 'A'],
    ['A', 'H', 'I', 'J', 'K', 'L', 'M', 'I'],
    ['G', 'N', 'O', 'P', 'Q', 'R', 'S', 'T'],
    ['E', 'U', 'V', 'W', 'X', 'Y', 'Z', 'E'],
    ['F', 'L', 'O', 'W', 'A', 'B', 'C', 'A'],
    ['D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'],
  ];

  final List<String> _targetWords = ['LAMP', 'MANGO', 'CHAI', 'SAGE', 'TEA', 'FLOW'];
  final Set<String> _foundWords = {};
  
  List<Offset> _currentSelection = [];
  final Set<Offset> _highlightedCells = {};

  @override
  void initState() {
    super.initState();
    _speakIntro();
  }

  void _speakIntro() {
    _ttsService.speak(
      "Welcome to Word Search. Try to find the gentle words listed below in the grid. Drag your finger across the letters.",
    );
  }

  void _onPanStart(DragStartDetails details, double cellSize) {
    _handlePan(details.localPosition, cellSize);
  }

  void _onPanUpdate(DragUpdateDetails details, double cellSize) {
    _handlePan(details.localPosition, cellSize);
  }

  void _onPanEnd(DragEndDetails details) {
    _checkSelection();
    setState(() {
      _currentSelection.clear();
    });
  }

  void _handlePan(Offset localPosition, double cellSize) {
    int col = (localPosition.dx / cellSize).floor();
    int row = (localPosition.dy / cellSize).floor();
    
    if (row >= 0 && row < 8 && col >= 0 && col < 8) {
      Offset cell = Offset(col.toDouble(), row.toDouble());
      if (_currentSelection.isEmpty || _currentSelection.last != cell) {
        setState(() {
          _currentSelection.add(cell);
        });
      }
    }
  }

  void _checkSelection() {
    if (_currentSelection.isEmpty) return;

    String selectedWord = '';
    for (var pos in _currentSelection) {
      selectedWord += _grid[pos.dy.toInt()][pos.dx.toInt()];
    }

    if (_targetWords.contains(selectedWord) && !_foundWords.contains(selectedWord)) {
      setState(() {
        _foundWords.add(selectedWord);
        _highlightedCells.addAll(_currentSelection);
      });
      _ttsService.speak("Wonderful! You found $selectedWord.");
      
      if (_foundWords.length == _targetWords.length) {
        Future.delayed(const Duration(seconds: 1), () {
          _ttsService.speak("Congratulations! You found all the words. Great job!");
          _showWinDialog();
        });
      }
    } else {
      // Also check reverse
      String reversedWord = selectedWord.split('').reversed.join('');
      if (_targetWords.contains(reversedWord) && !_foundWords.contains(reversedWord)) {
        setState(() {
          _foundWords.add(reversedWord);
          _highlightedCells.addAll(_currentSelection);
        });
        _ttsService.speak("Wonderful! You found $reversedWord.");
        
        if (_foundWords.length == _targetWords.length) {
          Future.delayed(const Duration(seconds: 1), () {
            _ttsService.speak("Congratulations! You found all the words. Great job!");
            _showWinDialog();
          });
        }
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Wonderful Job! 🎉',
          style: GoogleFonts.newsreader(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'You found all the gentle words today.',
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
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Back to Games',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Word Search',
          style: GoogleFonts.newsreader(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 26,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up, color: AppColors.primary),
            onPressed: _speakIntro,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Find these gentle words:',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            
            // Word Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: _targetWords.map((word) {
                  bool isFound = _foundWords.contains(word);
                  return Chip(
                    label: Text(
                      word,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isFound ? AppColors.onPrimary : AppColors.onSurface,
                        decoration: isFound ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    backgroundColor: isFound ? AppColors.primary : AppColors.surfaceContainerLowest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isFound ? AppColors.primary : AppColors.outlineVariant,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // The Grid
            Expanded(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double padding = 32.0;
                    double gridWidth = constraints.maxWidth - padding * 2;
                    if (gridWidth > 400) gridWidth = 400; // max width
                    double cellSize = gridWidth / 8;
                    
                    return GestureDetector(
                      onPanStart: (d) => _onPanStart(d, cellSize),
                      onPanUpdate: (d) => _onPanUpdate(d, cellSize),
                      onPanEnd: _onPanEnd,
                      child: Container(
                        width: gridWidth,
                        height: gridWidth,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.outlineVariant),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8,
                          ),
                          itemCount: 64,
                          itemBuilder: (context, index) {
                            int row = index ~/ 8;
                            int col = index % 8;
                            Offset cell = Offset(col.toDouble(), row.toDouble());
                            
                            bool isSelected = _currentSelection.contains(cell);
                            bool isHighlighted = _highlightedCells.contains(cell);
                            
                            return Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryContainer.withOpacity(0.5)
                                    : isHighlighted
                                        ? AppColors.primaryFixed
                                        : Colors.transparent,
                                border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  _grid[row][col],
                                  style: GoogleFonts.outfit(
                                    fontSize: 22,
                                    fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
                                    color: isHighlighted ? AppColors.primary : AppColors.onSurface,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
