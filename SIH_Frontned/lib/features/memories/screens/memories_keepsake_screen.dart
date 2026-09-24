import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';

class MemoriesKeepsakeScreen extends StatefulWidget {
  const MemoriesKeepsakeScreen({super.key});

  @override
  State<MemoriesKeepsakeScreen> createState() => _MemoriesKeepsakeScreenState();
}

class _MemoriesKeepsakeScreenState extends State<MemoriesKeepsakeScreen> {
  final TTSService _ttsService = TTSService();

  final List<Map<String, String>> _memories = [
    {
      'title': 'Monsoon Tea at Courtyard',
      'date': 'October 1994',
      'tag': 'FAMILY PHOTO',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCCIfEO_0JXjcS1pGOFlvZznkR40--FdKTvAsn7bWrVWpX36-xyZ2iIfWGCX5T9-b9GNvlPKoUDVg5ldZ9DCeEDo1wQM85nml9ucnH6cWkss1A8MUUcZtRmWFzY16e49KPLE16lQ8IRySRlUbWQToMrNpxX8m9tkvGQIjND6xF_8brpHxWqVMX6P7ymA1o9sPGJ3J18Kndr1RmJkWBglv7b4hwwAI1Nmqz-XM-L5NJXLz8i8Jx8LXRs',
      'audioNote': 'Priya recording: Ma, remember how we used to watch the rain sitting on the swing?',
    },
    {
      'title': 'Diwali Festivities with Grandkids',
      'date': 'November 2023',
      'tag': 'FESTIVAL KEEPSAKE',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCPmU9lAc8HXQTAMvSL4GOM1ka1TIs12X3kfzBF1xZlTICn8djsRKylWnvprCpQ7WYp1jTw5Sfi3YiYk59BYZRLwuV-jtOx1tzeLSmu8taqDtEA60Y-ziBI-FbRZf7iovQati-VbF9JnOBqZeWEbnKRLJRN9HzPW97CvC51a70fKtvETF-VI3f8W8jqdc2yObrrVNlTl9zDcYdGWXDlzl25DGAxuxNVDpezJa0eVUQHslyMzWAiWRiG',
      'audioNote': 'Aarav voice note: Grandma made the best gulab jamuns!',
    },
    {
      'title': 'Classical Sitar Evenings',
      'date': 'Summer 2010',
      'tag': 'MUSIC & MEMORY',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDjHS6vouMWhGEFFGISrr2WEZkXC3X0qPSASDuWYyEMPWKWSxOHs_yhoOJDsnoh3cS1q0nCnUd8qRxHYTx7qHLdT5Xmu9fQGdd43ENVTWjk2RWIuG9YpDLstRtizewD3LNJsD5k9_ho_h-J-bSuROUdJIeSzqm9WqOdy_jiN78NsfX1wlQg9hp-wzM6k2TUfB-El9SXtoMGbleidkY7iO_XkJJc7RsYyyxzYJhjiobXZaah5KWjBMSK',
      'audioNote': 'Raga Bhairavi playing softly in the courtyard.',
    },
  ];

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
                        color: AppColors.tertiaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.photo_album, color: AppColors.tertiary, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Family Keepsakes',
                      style: GoogleFonts.newsreader(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    _ttsService.speak("Here are your family keepsakes and photo albums.");
                  },
                  icon: const Icon(Icons.volume_up, color: AppColors.onSurface),
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
            Text(
              'Cherished Moments',
              style: GoogleFonts.newsreader(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap any memory card to view family photographs and listen to voice recordings.',
              style: GoogleFonts.outfit(
                fontSize: 15,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _memories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final memory = _memories[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 180,
                          width: double.infinity,
                          child: Image.network(
                            memory['imageUrl']!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppColors.secondaryContainer,
                              child: const Icon(Icons.photo, size: 48, color: AppColors.primary),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.tertiaryFixed,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      memory['tag']!,
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.tertiary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    memory['date']!,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                memory['title']!,
                                style: GoogleFonts.newsreader(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () {
                                  _ttsService.speak(memory['audioNote']!);
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.play_circle_fill, color: AppColors.tertiary, size: 24),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          memory['audioNote']!,
                                          style: GoogleFonts.outfit(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            color: AppColors.onSurface,
                                          ),
                                        ),
                                      ),
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
