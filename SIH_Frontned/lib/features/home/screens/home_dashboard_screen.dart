import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';
import '../../profile/screens/patient_profile_screen.dart';
import '../../language/screens/language_selection_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  final VoidCallback onStartActivity;
  final VoidCallback onEmergencyContact;

  const HomeDashboardScreen({
    super.key,
    required this.onStartActivity,
    required this.onEmergencyContact,
  });

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  String _selectedMood = 'Calm';
  bool _isPlayingVoiceNote = false;
  final TTSService _ttsService = TTSService();

  void _speakOverview() {
    _ttsService.speak(
      "Namaste Lakshmi. Today is sunny and peaceful. Priya sent a voice message: Thinking of you Ma, loved looking at the monsoon photos yesterday.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: AppColors.background.withOpacity(0.95),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_florist,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Nenil',
                          style: GoogleFonts.newsreader(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          'COGNITIVE LIVING',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _speakOverview,
                      icon: const Icon(Icons.volume_up, color: AppColors.onSurface, size: 24),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surfaceContainerHigh,
                        minimumSize: const Size(48, 48),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()));
                      },
                      icon: const Icon(Icons.language, color: AppColors.onSurface, size: 24),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surfaceContainerHigh,
                        minimumSize: const Size(48, 48),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientProfileScreen()));
                      },
                      icon: const Icon(Icons.person, color: AppColors.onSurface, size: 24),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surfaceContainerHigh,
                        minimumSize: const Size(48, 48),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: widget.onEmergencyContact,
                      icon: const Icon(Icons.support_agent, color: AppColors.tertiary, size: 24),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.tertiaryFixed,
                        minimumSize: const Size(48, 48),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Welcoming Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Namaste, Lakshmi',
                      style: GoogleFonts.newsreader(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.wb_sunny,
                          color: AppColors.tertiary,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Sunny & Peaceful, 24°C',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryFixed.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.tertiaryContainer,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '5 Days Joy',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mood Check-in Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'How are you feeling this morning?',
                        style: GoogleFonts.newsreader(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const Icon(Icons.nature, color: AppColors.primary, size: 22),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMoodButton('Calm', '😌'),
                      const SizedBox(width: 8),
                      _buildMoodButton('Happy', '😊'),
                      const SizedBox(width: 8),
                      _buildMoodButton('Engaged', '✨'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Flagship Activity Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.primaryContainer.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'RECOMMENDED FOR TODAY • 4 MIN',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onPrimaryContainer,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Match familiar household objects',
                              style: GoogleFonts.newsreader(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Enjoy gentle pairing of brass lamps, ripe mangoes, and cozy tea cups.',
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBunyMECe0n0H6W4p7Y9mg4EeuV7ONfvFU7FgDjoBEztePaPufvXukVAcAwKm3zvyFc6iZj_e46Ech2qQ9H2yBrLNd_2KzOhdaOPkTUppwxc7QJDbqzSrLVnuDvPuquUl4BsVTp4jqtXZBKAbOWn2R7k6K1Z3Bf5UgiaGg5r4AKaXpDyt6o6qDMIdKUk14AozVWBLS_gx2tgcAog6g9SL1xrn_MSWxh4IEkUyVNkLx4q6Y8oJc0n8YB',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppColors.secondaryContainer,
                              child: const Icon(Icons.style, color: AppColors.primary, size: 36),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: widget.onStartActivity,
                      icon: const Icon(Icons.play_circle, size: 24),
                      label: Text(
                        'Begin Activity',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Caregiver Message Preview Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: AppColors.tertiaryFixed,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                'P',
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.tertiary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Priya (Daughter)',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              Text(
                                'Sent today at 8:30 AM',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.favorite, color: AppColors.tertiary, size: 24),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '“Thinking of you Ma! Loved looking at the monsoon photos with you yesterday. ♥”',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isPlayingVoiceNote = !_isPlayingVoiceNote;
                      });
                      if (_isPlayingVoiceNote) {
                        _ttsService.speak(
                          "Thinking of you Ma! Loved looking at the monsoon photos with you yesterday.",
                        );
                      } else {
                        _ttsService.stop();
                      }
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isPlayingVoiceNote ? Icons.pause : Icons.play_arrow,
                                color: AppColors.primary,
                                size: 26,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isPlayingVoiceNote ? 'Playing message...' : 'Play Voice Note (0:45)',
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.graphic_eq, color: AppColors.primary, size: 22),
                        ],
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

  Widget _buildMoodButton(String label, String emoji) {
    final isSelected = _selectedMood == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMood = label;
          });
        },
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
