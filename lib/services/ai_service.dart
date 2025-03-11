import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  static const String _apiKey = 'AIzaSyDJqZZBBGXFBEL9yGvJ1kEFXH_Yt_YoMtE'; // Replace if you want to use your own key
  late final GenerativeModel _model;
  
  AiService() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
    );
  }

  Future<String> getResponse(String prompt) async {
    try {
      final content = [
        Content.text(
          '''You are a helpful AI assistant for "Ban Hunger", a food donation app focused on connecting food donors with people in need. 
          Your primary purpose is to help:
          
          For Donors:
          1. Guide them through the food donation process
          2. Provide food safety and packaging guidelines
          3. Explain best practices for food storage and transportation
          4. Help schedule pickups or arrange deliveries
          5. Share impact stories and donation statistics
          
          For Recipients:
          1. Help find available food donations nearby
          2. Explain how to request food assistance
          3. Provide information about food collection points
          4. Share guidelines for safe food handling
          5. Connect with emergency food services
          
          For Community Members:
          1. Organize community kitchens and food drives
          2. Coordinate volunteer activities
          3. Share success stories and impact metrics
          4. Build local support networks
          
          App Features:
          - Donate Screen: Share food, request pickups, join community kitchen, register as restaurant partner
          - Request Screen: Find available food, emergency assistance
          - Community Screen: Share experiences, coordinate efforts
          - Profile Screen: Track donation/request history
          
          Food Safety Priority:
          - Always emphasize food safety
          - Provide clear guidelines for food handling
          - Help identify safe food storage practices
          - Guide proper packaging methods
          
          Please provide helpful, accurate, and compassionate responses focused on fighting hunger through community connection.
          Current prompt: $prompt'''
        ),
      ];

      final response = await _model.generateContent(content);
      if (response.text == null || response.text!.isEmpty) {
        return 'I apologize, but I couldn\'t generate a response. Please try asking in a different way.';
      }
      return response.text!;
    } catch (e) {
      if (e.toString().contains('API key')) {
        return 'Error: Invalid API key. Please contact the app administrator.';
      } else if (e.toString().contains('network')) {
        return 'Error: Please check your internet connection and try again.';
      }
      return 'Sorry, I encountered an error. Please try again later. Error: ${e.toString()}';
    }
  }
} 