import 'package:http/http.dart' as http;
import 'dart:convert' show jsonEncode, jsonDecode, utf8;

class GptService {
  final String _apiKey = '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';

  Future<String> generateResponse(List<Map<String, dynamic>> messages) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': messages,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      print('Response from GPT-3.5 Turbo: $jsonResponse');
      return jsonResponse['choices'][0]['message']['content'].trim();
    } else {
      print('Error from GPT-3.5 Turbo: ${response.body}');
      throw Exception('Failed to generate response');
    }
  }
}
