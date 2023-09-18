import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatgptAPI {
  final String apiKey; // Your API key

  ChatgptApi(this.apiKey);

  Future<Map<String, dynamic>> sendChatGPTRequest(String message) async {
    final String apiUrl = 'https://api.openai.com/v1/chat/completions';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': message},
        ],
        'max_tokens': 1000,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> translateQuizQuestions(String message) async {
    final response = await sendChatGPTRequest(utf8.decode(utf8.encode(message)));
    final choices = response['choices'];
    
    if (choices != null && choices.isNotEmpty) {
      final completion = choices[0];
      final message = completion['message'];
      
      if (message != null && message['content'] != null) {
        final content = message['content'] as String;
        final questionsStartIndex = content.indexOf('[');
        final questionsEndIndex = content.indexOf(']');
        final suggestion1 = content.substring(questionsStartIndex + 1, questionsEndIndex).split(', ');
        
        Map<String, dynamic> suggestions = {
          'Suggestions': suggestion1,
        };
        
        return suggestions;
      }
    }

    // Return an empty map if translation fails
    return {};
  }
}
