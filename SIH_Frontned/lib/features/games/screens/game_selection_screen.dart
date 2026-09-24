import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class GameSelectionScreen extends StatefulWidget {
  final VoidCallback onSelectMemoryMatch;
  final VoidCallback onSelectWordSearch;
  final VoidCallback onSelectRegionalQuiz;

  const GameSelectionScreen({
    super.key,
    required this.onSelectMemoryMatch,
    required this.onSelectWordSearch,
    required this.onSelectRegionalQuiz,
  });

  @override
  State<GameSelectionScreen> createState() => _GameSelectionScreenState();
}

class _GameSelectionScreenState extends State<GameSelectionScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.local_florist, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Nenil',
                      style: GoogleFonts.newsreader(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.volume_up, color: AppColors.onSurface, size: 24),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.spa, color: AppColors.primary, size: 16),
                ),
                const SizedBox(width: 6),
                Text(
                  'MORNING COGNITIVE FLOW',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Gentle Activities',
              style: GoogleFonts.newsreader(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pick a mindful game to play at your own pace. There is no timer and no rush.',
              style: GoogleFonts.outfit(
                fontSize: 15,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // Tabs Bar
            Container(
              height: 46,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  _buildTab('All (5)', 0, Icons.grid_view),
                  _buildTab('Favorites', 1, Icons.favorite),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Milestone Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryFixed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.psychology_alt, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your gentle milestone',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          '1 calm session completed yesterday. Wonderful rhythm!',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card 1: Memory Match
            _buildGameCard(
              title: 'Memory Match',
              category: 'DAILY FAVORITE • 3–5 MIN',
              description: 'Pair familiar cultural objects like brass lamps, ripe mangoes & warm chai cups.',
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC8i2_lFinWtKOZTK5Ej3S8tg6B1dgPvH8gh1GIOp0JZeaijfcYXEBj8bvCZAAFFJ45Je9j1Tl75ls-vjXuTp4jodMfXHNOVA9O2gGGYnJX0khhVe5gZYndMZMwLmN1HMu8foeeBP77-lI5JCP5fARFD_hKp7yLkcic11nQFAzrpTuWdIYF3CKiWBFJtCi8Z5ddYF82KG-RelgdAI8J35au3IgNLeivutDqD2VSS36yKinbGpFrUe_S',
              tags: ['Easy visual tiles', '6 soft cards'],
              buttonLabel: 'Play Now',
              onTap: widget.onSelectMemoryMatch,
              buttonColor: AppColors.primary,
            ),
            const SizedBox(height: 20),

            // Card 2: Word Search
            _buildGameCard(
              title: 'Word Search',
              category: 'LANGUAGE & FOCUS • 4 MIN',
              description: 'Find familiar, gentle words in a calming grid.',
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDjHS6vouMWhGEFFGISrr2WEZkXC3X0qPSASDuWYyEMPWKWSxOHs_yhoOJDsnoh3cS1q0nCnUd8qRxHYTx7qHLdT5Xmu9fQGdd43ENVTWjk2RWIuG9YpDLstRtizewD3LNJsD5k9_ho_h-J-bSuROUdJIeSzqm9WqOdy_jiN78NsfX1wlQg9hp-wzM6k2TUfB-El9SXtoMGbleidkY7iO_XkJJc7RsYyyxzYJhjiobXZaah5KWjBMSK',
              tags: ['Word discovery', 'Calming'],
              buttonLabel: 'Play Now',
              onTap: widget.onSelectWordSearch,
              buttonColor: AppColors.tertiary,
            ),
            const SizedBox(height: 20),

            // Card 3: Regional Quiz
            _buildGameCard(
              title: 'Cultural Quiz',
              category: 'MEMORY & HERITAGE • 5 MIN',
              description: 'Recall and celebrate cultural heritage through gentle questions.',
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCCIfEO_0JXjcS1pGOFlvZznkR40--FdKTvAsn7bWrVWpX36-xyZ2iIfWGCX5T9-b9GNvlPKoUDVg5ldZ9DCeEDo1wQM85nml9ucnH6cWkss1A8MUUcZtRmWFzY16e49KPLE16lQ8IRySRlUbWQToMrNpxX8m9tkvGQIjND6xF_8brpHxWqVMX6P7ymA1o9sPGJ3J18Kndr1RmJkWBglv7b4hwwAI1Nmqz-XM-L5NJXLz8i8Jx8LXRs',
              tags: ['Heritage', 'Audio-guided'],
              buttonLabel: 'Begin Quiz',
              onTap: widget.onSelectRegionalQuiz,
              buttonColor: AppColors.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index, IconData icon) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceContainerLowest : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: isSelected
                ? const [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required String title,
    required String category,
    required String description,
    required String imageUrl,
    required List<String> tags,
    required String buttonLabel,
    required VoidCallback onTap,
    required Color buttonColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.secondaryContainer,
                      child: const Icon(Icons.image, size: 48, color: AppColors.primary),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite, color: AppColors.tertiary, size: 22),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.newsreader(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: tags
                        .map(
                          (tag) => Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, size: 16, color: AppColors.secondary),
                                const SizedBox(width: 4),
                                Text(
                                  tag,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.play_arrow, size: 24),
                      label: Text(
                        buttonLabel,
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
