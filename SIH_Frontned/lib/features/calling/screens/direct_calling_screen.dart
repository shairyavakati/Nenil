import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';

class DirectCallingScreen extends StatefulWidget {
  const DirectCallingScreen({super.key});

  @override
  State<DirectCallingScreen> createState() => _DirectCallingScreenState();
}

class _DirectCallingScreenState extends State<DirectCallingScreen> {
  final TTSService _ttsService = TTSService();

  final List<Map<String, dynamic>> _contacts = [
    {
      'name': 'Priya (Daughter)',
      'role': 'Primary Caregiver',
      'phone': 'tel:+919876543210',
      'icon': Icons.favorite,
      'color': AppColors.tertiary,
    },
    {
      'name': 'Dr. Rajesh',
      'role': 'Geriatric Specialist',
      'phone': 'tel:+919876543211',
      'icon': Icons.medical_services,
      'color': AppColors.primary,
    },
    {
      'name': 'Emergency 108',
      'role': '24/7 Medical Helpline',
      'phone': 'tel:108',
      'icon': Icons.local_hospital,
      'color': Colors.red.shade700,
    }
  ];

  void _speakInstruction() {
    _ttsService.speak(
      "Emergency and Support calling. Tap on any card to call Priya, your doctor, or the emergency helpline.",
    );
  }

  Future<void> _makeCall(String url, String name) async {
    final Uri uri = Uri.parse(url);
    _ttsService.speak("Calling $name");
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _ttsService.speak("Unable to place the call right now.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not launch dialer for $name"),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
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
          'Emergency & Calling',
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Direct Assistance',
                style: GoogleFonts.newsreader(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap any card below to instantly call for support or medical help.',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              
              Expanded(
                child: ListView.separated(
                  itemCount: _contacts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final contact = _contacts[index];
                    return Material(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(24),
                      elevation: 2,
                      child: InkWell(
                        onTap: () => _makeCall(contact['phone'], contact['name']),
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.outlineVariant,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: contact['color'].withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  contact['icon'],
                                  color: contact['color'],
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      contact['name'],
                                      style: GoogleFonts.outfit(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      contact['role'],
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
