import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final TTSService _ttsService = TTSService();
  String _selectedState = 'Core';
  String _selectedLanguage = 'English';

  final Map<String, List<String>> _stateLanguages = {
    'Core': ['English', 'Hindi (हिंदी)', 'Tamil', 'Telugu', 'Kannada', 'Bengali'],
    'Arunachal Pradesh': ['Nyishi', 'Adi', 'Galo', 'Tagin', 'Apatani', 'Wancho', 'Tangsa', 'Nocte', 'Mishmi', 'Nepali', 'Assamese'],
    'Assam': ['Assamese', 'Bengali', 'Bodo', 'Karbi', 'Mising', 'Garo', 'Dimasa', 'Rabha', 'Tiwa', 'Deori', 'Nepali'],
    'Manipur': ['Meitei/Manipuri', 'Tangkhul', 'Thadou-Kuki', 'Paite', 'Hmar', 'Rongmei/Kabui', 'Liangmai', 'Gangte', 'Vaiphei', 'Zeme', 'Bengali', 'Nepali'],
    'Meghalaya': ['Khasi', 'Garo/A\'chik', 'Pnar/Jaintia', 'War', 'Bengali', 'Assamese', 'Nepali', 'Hajong'],
    'Mizoram': ['Mizo/Lushai', 'Hmar', 'Lai', 'Mara', 'Paite', 'Thadou-Kuki', 'Chakma', 'Meitei', 'Bengali', 'Nagamese'],
    'Nagaland': ['Nagamese', 'Angami', 'Ao', 'Lotha', 'Sumi', 'Konyak', 'Chakhesang', 'Chang', 'Sangtam', 'Yimkhiung', 'Rengma', 'Phom', 'Pochuri', 'Khiamniungan', 'Zeme', 'Rongmei'],
    'Sikkim': ['Nepali', 'Sikkimese/Bhutia', 'Lepcha', 'Limbu', 'Tamang', 'Rai/Kiranti', 'Sherpa', 'Bengali'],
    'Tripura': ['Bengali', 'Kokborok', 'Chakma', 'Reang/Bru', 'Halam', 'Mog'],
  };

  void _speakInstruction() {
    _ttsService.speak("Select your preferred language. Tap on a language to hear a preview, and then tap Save Language.");
  }

  void _previewLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    // In a real implementation, you would change TTS locale based on language if supported.
    _ttsService.speak("You have selected $language.");
  }

  void _saveLanguage() {
    _ttsService.speak("Language saved successfully.");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$_selectedLanguage saved successfully!',
          style: GoogleFonts.outfit(fontSize: 16),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLanguages = _stateLanguages[_selectedState] ?? [];

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
          'Language Selection',
          style: GoogleFonts.newsreader(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 26,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up, color: AppColors.primary),
            onPressed: _speakInstruction,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // State Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: AppColors.surfaceContainerLowest,
              child: DropdownButtonFormField<String>(
                value: _selectedState,
                decoration: InputDecoration(
                  labelText: 'Select Region/State',
                  labelStyle: GoogleFonts.outfit(color: AppColors.onSurfaceVariant),
                  prefixIcon: const Icon(Icons.map, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                items: _stateLanguages.keys.map((String state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(
                      state,
                      style: GoogleFonts.outfit(fontSize: 16, color: AppColors.onSurface),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedState = value;
                    });
                  }
                },
              ),
            ),
            
            // Language Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: currentLanguages.length,
                itemBuilder: (context, index) {
                  final lang = currentLanguages[index];
                  final isSelected = _selectedLanguage == lang;
                  return InkWell(
                    onTap: () => _previewLanguage(lang),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryFixed : AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              lang,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? AppColors.primary : AppColors.onSurface,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                            ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Icon(
                              Icons.volume_up,
                              color: isSelected ? AppColors.primary : AppColors.outline,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Save Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _saveLanguage,
                  icon: const Icon(Icons.language, size: 24),
                  label: Text(
                    'Save Language',
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
                    elevation: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
