import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../welcome/screens/welcome_screen.dart';
import '../../home/screens/home_dashboard_screen.dart';
import '../../games/screens/game_selection_screen.dart';
import '../../games/screens/memory_match_game_screen.dart';
import '../../games/screens/word_search_game_screen.dart';
import '../../games/screens/regional_quiz_game_screen.dart';
import '../../memories/screens/memories_keepsake_screen.dart';
import '../../caregiver/screens/caregiver_hub_screen.dart';
import '../../calling/screens/direct_calling_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  bool _showWelcomeScreen = true;
  Widget? _fullScreenWidget;

  void _onTabTapped(int index) {
    setState(() {
      _showWelcomeScreen = false;
      _fullScreenWidget = null;
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showWelcomeScreen) {
      return WelcomeScreen(
        onStartActivity: () {
          setState(() {
            _showWelcomeScreen = false;
            _currentIndex = 0;
          });
        },
        onBrowseMemories: () {
          setState(() {
            _showWelcomeScreen = false;
            _currentIndex = 2;
          });
        },
      );
    }

    if (_fullScreenWidget != null) {
      // If it's a game or calling screen, we might need a back button if they don't have one,
      // but they already have AppBars with back buttons in our design.
      // We just need to catch the pop. Actually, since we're rendering it directly,
      // the built-in Navigator.pop inside those screens will pop the MainNavigationScreen itself.
      // So we should wrap it in a Navigator or use Navigator.push for full screens.
      
      // A better approach is to not render them here but let the child handle it,
      // or we just return it. If the child calls Navigator.pop, it pops the whole app.
      // Let's just wrap with a simple WillPopScope or we just push it normally.
      
      // Wait, the previous code returned MemoryMatchGameScreen(onBack: ...).
      // Since we changed the new screens to use Navigator.pop, we should push them using Navigator.
      // I will revert _fullScreenWidget and just use Navigator.push in the callbacks.
    }

    final List<Widget> pages = [
      HomeDashboardScreen(
        onStartActivity: () {
          _onTabTapped(1);
        },
        onEmergencyContact: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DirectCallingScreen()));
        },
      ),
      GameSelectionScreen(
        onSelectMemoryMatch: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => MemoryMatchGameScreen(
            onBack: () => Navigator.pop(context)
          )));
        },
        onSelectWordSearch: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const WordSearchGameScreen()));
        },
        onSelectRegionalQuiz: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const RegionalQuizGameScreen()));
        },
      ),
      const MemoriesKeepsakeScreen(),
      const CaregiverHubScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.95),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.cottage, 'Home'),
                _buildNavItem(1, Icons.extension, 'Play'),
                _buildNavItem(2, Icons.photo_album, 'Memories'),
                _buildNavItem(3, Icons.volunteer_activism, 'Caregiver'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryFixed.withOpacity(0.4) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
