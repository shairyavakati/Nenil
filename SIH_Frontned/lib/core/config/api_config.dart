/// Configuration for aligning Flutter Frontend with the Live Backend
class ApiConfig {
  // Live Render backend URL (or custom domain)
  // If running locally on emulator use http://10.0.2.2:8000
  // If running locally on physical device use http://<your-computer-ip>:8000
  static const String liveBackendUrl = "https://sih-backend.onrender.com";
  
  static String get baseUrl => liveBackendUrl;
  static String get apiV1 => "$baseUrl/api/v1";

  // API Endpoints
  static String get authLogin => "$apiV1/auth/login";
  static String get patientPinLogin => "$apiV1/auth/patient/pin-login";
  static String get patientProfile => "$apiV1/patient";
  static String get voiceAgent => "$apiV1/voice/interact";
  static String get calling => "$apiV1/calling";
  static String get location => "$apiV1/location";
  static String get games => "$apiV1/games";
}
