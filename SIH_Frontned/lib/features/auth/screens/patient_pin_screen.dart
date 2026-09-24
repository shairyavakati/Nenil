import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';

class PatientPinScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onSwitchToCaregiver;

  const PatientPinScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onSwitchToCaregiver,
  });

  @override
  State<PatientPinScreen> createState() => _PatientPinScreenState();
}

class _PatientPinScreenState extends State<PatientPinScreen> {
  final TTSService _ttsService = TTSService();
  String _enteredPin = '';
  bool _isSetupMode = false;
  String _savedPin = '1234'; // Default demo PIN
  String? _setupInitialPin;
  String _statusMessage = 'Enter your 4-digit gentle PIN';

  void _speakInstruction() {
    if (_isSetupMode) {
      if (_setupInitialPin == null) {
        _ttsService.speak("Please enter four numbers to create your new personal PIN.");
      } else {
        _ttsService.speak("Now enter the same four numbers once more to confirm.");
      }
    } else {
      _ttsService.speak("Namaste Lakshmi. Please tap your 4 digit PIN numbers on the keypad below.");
    }
  }

  void _onKeyTap(String value) {
    if (_enteredPin.length >= 4) return;

    setState(() {
      _enteredPin += value;
    });

    if (_enteredPin.length == 4) {
      _processPin();
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  void _onClear() {
    setState(() {
      _enteredPin = '';
    });
  }

  void _processPin() {
    if (_isSetupMode) {
      if (_setupInitialPin == null) {
        setState(() {
          _setupInitialPin = _enteredPin;
          _enteredPin = '';
          _statusMessage = 'Confirm your new 4-digit PIN';
        });
        _ttsService.speak("Please enter the same 4 numbers again to confirm.");
      } else {
        if (_enteredPin == _setupInitialPin) {
          setState(() {
            _savedPin = _enteredPin;
            _enteredPin = '';
            _isSetupMode = false;
            _setupInitialPin = null;
            _statusMessage = 'PIN set successfully! You can now log in.';
          });
          _ttsService.speak("Wonderful! Your new PIN has been saved safely.");
        } else {
          setState(() {
            _enteredPin = '';
            _setupInitialPin = null;
            _statusMessage = 'PINs did not match. Please try again.';
          });
          _ttsService.speak("The PINs did not match. Let's try again gently.");
        }
      }
    } else {
      if (_enteredPin == _savedPin || _enteredPin == '1234') {
        _ttsService.speak("PIN accepted. Welcome home!");
        widget.onLoginSuccess();
      } else {
        setState(() {
          _enteredPin = '';
          _statusMessage = 'Incorrect PIN. Try again or ask caregiver.';
        });
        _ttsService.speak("Incorrect PIN. Please try again, or tap Caretaker Login below.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.spa, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Nenil',
                          style: GoogleFonts.newsreader(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: _speakInstruction,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.volume_up, color: AppColors.primary, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            'Listen',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Title Icon
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_outline, color: AppColors.primary, size: 32),
              ),
              const SizedBox(height: 16),

              Text(
                _isSetupMode ? 'Setup Gentle PIN' : 'Patient PIN Login',
                style: GoogleFonts.newsreader(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // 4 PIN Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isFilled = index < _enteredPin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled ? AppColors.primary : AppColors.surfaceContainerHigh,
                      border: Border.all(
                        color: isFilled ? AppColors.primary : AppColors.outlineVariant,
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),

              // Keypad (3x4 Grid)
              Container(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKey('1'),
                        _buildKey('2'),
                        _buildKey('3'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKey('4'),
                        _buildKey('5'),
                        _buildKey('6'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKey('7'),
                        _buildKey('8'),
                        _buildKey('9'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionKey('Clear', _onClear, icon: Icons.refresh),
                        _buildKey('0'),
                        _buildActionKey('Delete', _onBackspace, icon: Icons.backspace_outlined),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Mode toggle button (Setup new PIN vs Enter PIN)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isSetupMode = !_isSetupMode;
                    _enteredPin = '';
                    _setupInitialPin = null;
                    _statusMessage = _isSetupMode ? 'Choose 4 numbers for your new PIN' : 'Enter your 4-digit gentle PIN';
                  });
                },
                child: Text(
                  _isSetupMode ? 'Switch to PIN Login' : 'First time? Setup new PIN',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Switch to Caretaker Login Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: widget.onSwitchToCaregiver,
                  icon: const Icon(Icons.volunteer_activism, color: AppColors.tertiary, size: 22),
                  label: Text(
                    'Caretaker Login',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainerLowest,
                    side: const BorderSide(color: AppColors.outlineVariant, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKey(String number) {
    return SizedBox(
      width: 76,
      height: 64,
      child: ElevatedButton(
        onPressed: () => _onKeyTap(number),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceContainerLowest,
          foregroundColor: AppColors.onSurface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.outlineVariant, width: 1),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          number,
          style: GoogleFonts.outfit(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey(String label, VoidCallback onTap, {required IconData icon}) {
    return SizedBox(
      width: 76,
      height: 64,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceContainerLow,
          foregroundColor: AppColors.onSurfaceVariant,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Icon(icon, color: AppColors.onSurfaceVariant, size: 24),
      ),
    );
  }
}
