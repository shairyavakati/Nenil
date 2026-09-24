import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';

class MemoryMatchItem {
  final int id;
  final String title;
  final String imageUrl;
  final IconData placeholderIcon;
  bool isMatched;
  bool isFlipped;

  MemoryMatchItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.placeholderIcon,
    this.isMatched = false,
    this.isFlipped = false,
  });
}

class MemoryMatchGameScreen extends StatefulWidget {
  final VoidCallback onBack;

  const MemoryMatchGameScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<MemoryMatchGameScreen> createState() => _MemoryMatchGameScreenState();
}

class _MemoryMatchGameScreenState extends State<MemoryMatchGameScreen> {
  final TTSService _ttsService = TTSService();
  late List<MemoryMatchItem> _cards;
  int? _firstFlippedIndex;
  bool _isProcessing = false;
  int _matchedPairsCount = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    _cards = [
      MemoryMatchItem(
        id: 1,
        title: 'Brass Lamp',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCPmU9lAc8HXQTAMvSL4GOM1ka1TIs12X3kfzBF1xZlTICn8djsRKylWnvprCpQ7WYp1jTw5Sfi3YiYk59BYZRLwuV-jtOx1tzeLSmu8taqDtEA60Y-ziBI-FbRZf7iovQati-VbF9JnOBqZeWEbnKRLJRN9HzPW97CvC51a70fKtvETF-VI3f8W8jqdc2yObrrVNlTl9zDcYdGWXDlzl25DGAxuxNVDpezJa0eVUQHslyMzWAiWRiG',
        placeholderIcon: Icons.local_florist,
        isMatched: true,
        isFlipped: true,
      ),
      MemoryMatchItem(
        id: 1,
        title: 'Brass Lamp',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBkiZs6EnG_isSvr5S9wMjNxj4lrBQLMU9sDcZNHVQZzCLJWRhyrTM-U0K2QVlUi0esmcJ9u5tzFVzD7koRjftMVbsvOk-lcSR2HpOOZ7S53f3SBtnPWlwnB2UcymQUhHup0Srbko2gmmqBCYSBvzQSN2_BTZpMrQYRVf7moHRj5L1wQYN6ajpQVzNZtq0ziKpYZTLDyCNg6ICKCzm8bl58O9bcThBtX21qOnicpzu4G9YQ_7njdg7L',
        placeholderIcon: Icons.local_florist,
        isMatched: true,
        isFlipped: true,
      ),
      MemoryMatchItem(
        id: 2,
        title: 'Sweet Mango',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDCLpucsO1OY6ixJ79AXuJ_zsTZvhp2oxmUYmtHE03L7jaqDJJvAgYprQiV9f9o4hYVotPRYhRI8NoKNoahxaDpG9Rjrzwh18uiw9yQ-lvbnc6d-yjg1nNp_aKZ1Zdq7Kj_RhCYuyhQCEb0XKWv0Kx7XFOSW51jKVe3UMdCsRa3990FcDZSJKTJwRBy2389X2o_OAFqU1t2jRkZzs4Thq5MfPp1lUtklhgWJlJ4U2Ut-RcLsnF7kN87',
        placeholderIcon: Icons.yard,
        isMatched: false,
        isFlipped: true,
      ),
      MemoryMatchItem(
        id: 2,
        title: 'Sweet Mango',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDCLpucsO1OY6ixJ79AXuJ_zsTZvhp2oxmUYmtHE03L7jaqDJJvAgYprQiV9f9o4hYVotPRYhRI8NoKNoahxaDpG9Rjrzwh18uiw9yQ-lvbnc6d-yjg1nNp_aKZ1Zdq7Kj_RhCYuyhQCEb0XKWv0Kx7XFOSW51jKVe3UMdCsRa3990FcDZSJKTJwRBy2389X2o_OAFqU1t2jRkZzs4Thq5MfPp1lUtklhgWJlJ4U2Ut-RcLsnF7kN87',
        placeholderIcon: Icons.yard,
        isMatched: false,
        isFlipped: false,
      ),
      MemoryMatchItem(
        id: 3,
        title: 'Chai Cup',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBunyMECe0n0H6W4p7Y9mg4EeuV7ONfvFU7FgDjoBEztePaPufvXukVAcAwKm3zvyFc6iZj_e46Ech2qQ9H2yBrLNd_2KzOhdaOPkTUppwxc7QJDbqzSrLVnuDvPuquUl4BsVTp4jqtXZBKAbOWn2R7k6K1Z3Bf5UgiaGg5r4AKaXpDyt6o6qDMIdKUk14AozVWBLS_gx2tgcAog6g9SL1xrn_MSWxh4IEkUyVNkLx4q6Y8oJc0n8YB',
        placeholderIcon: Icons.coffee,
        isMatched: false,
        isFlipped: false,
      ),
      MemoryMatchItem(
        id: 3,
        title: 'Chai Cup',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBunyMECe0n0H6W4p7Y9mg4EeuV7ONfvFU7FgDjoBEztePaPufvXukVAcAwKm3zvyFc6iZj_e46Ech2qQ9H2yBrLNd_2KzOhdaOPkTUppwxc7QJDbqzSrLVnuDvPuquUl4BsVTp4jqtXZBKAbOWn2R7k6K1Z3Bf5UgiaGg5r4AKaXpDyt6o6qDMIdKUk14AozVWBLS_gx2tgcAog6g9SL1xrn_MSWxh4IEkUyVNkLx4q6Y8oJc0n8YB',
        placeholderIcon: Icons.coffee,
        isMatched: false,
        isFlipped: false,
      ),
    ];
    _matchedPairsCount = 1; // 1 pair pre-matched for delightful demo state
  }

  void _onCardTap(int index) {
    if (_isProcessing) return;
    final card = _cards[index];
    if (card.isFlipped || card.isMatched) return;

    setState(() {
      card.isFlipped = true;
    });

    if (_firstFlippedIndex == null) {
      _firstFlippedIndex = index;
    } else {
      final firstCard = _cards[_firstFlippedIndex!];
      if (firstCard.id == card.id) {
        // Matched!
        setState(() {
          firstCard.isMatched = true;
          card.isMatched = true;
          _matchedPairsCount++;
          _firstFlippedIndex = null;
        });
        _ttsService.speak("Wonderful match! You matched both ${card.title}s.");
      } else {
        // Not matched - flip back
        _isProcessing = true;
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              firstCard.isFlipped = false;
              card.isFlipped = false;
              _firstFlippedIndex = null;
              _isProcessing = false;
            });
          }
        });
      }
    }
  }

  void _speakPraise() {
    _ttsService.speak(
      "Wonderful match! You discovered both Brass Lamps. They bring peaceful light into the morning room.",
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
          onPressed: widget.onBack,
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface, size: 26),
        ),
        title: Text(
          'Game Session',
          style: GoogleFonts.newsreader(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _speakPraise,
            icon: const Icon(Icons.volume_up, color: AppColors.onSurface, size: 24),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Column(
          children: [
            // Session Sub-header Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: Text('Pause', style: GoogleFonts.outfit(fontSize: 15)),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainerLow,
                    foregroundColor: AppColors.onSurface,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: AppColors.onPrimaryContainer, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '$_matchedPairsCount of 3 Pairs Matched',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _speakPraise,
                  icon: const Icon(Icons.volume_up, color: AppColors.onSurface),
                  style: IconButton.styleFrom(backgroundColor: AppColors.secondaryFixed),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Encouragement Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.spa, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find the matching pairs',
                        style: GoogleFonts.newsreader(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        'Take all the peaceful time you need.',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2x3 Grid of Memory Cards
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final card = _cards[index];
                return GestureDetector(
                  onTap: () => _onCardTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: card.isFlipped
                          ? AppColors.surfaceContainerLowest
                          : (index % 2 == 0 ? AppColors.primaryFixed : AppColors.tertiaryFixed),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: card.isFlipped
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  card.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: AppColors.surfaceContainer,
                                    child: Icon(card.placeholderIcon, size: 48, color: AppColors.primary),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.white.withOpacity(0.9),
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      card.title,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                                if (card.isMatched)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check, color: Colors.white, size: 16),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  card.placeholderIcon,
                                  color: AppColors.primary,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to See',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Praise & Celebration Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Wonderful match!',
                        style: GoogleFonts.newsreader(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'You discovered both Brass Lamps. They bring peaceful light into the morning room.',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _speakPraise,
                    child: Row(
                      children: [
                        const Icon(Icons.volume_up, color: AppColors.primary, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          'Replay voice praise',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Gentle Assistance Hint Bar
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  _ttsService.speak("Try tapping the top right card to see if it matches the sweet mango.");
                },
                icon: const Icon(Icons.lightbulb, color: AppColors.tertiary, size: 24),
                label: Text(
                  'Would you like a gentle hint?',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerLowest,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No rush. Relax your hands and breathe deeply.',
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
