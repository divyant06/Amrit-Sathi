import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  const systemPrompt = 'You are Amrit Sathi...';
  final model = GenerativeModel(
    model: 'gemini-flash-latest',
    apiKey: 'AIzaSyCQXAjQHYIevvhhmWRrWfj5jquxVglIg_Q',
    systemInstruction: Content.system(systemPrompt),
  );
  final chat = model.startChat();

  try {
    stdout.writeln('sending...');
    final response = await chat.sendMessage(Content.text('Hello'));
    File('err.txt').writeAsStringSync('SUCCESS: ${response.text}');
  } catch (e, st) {
    File('err.txt').writeAsStringSync('ERROR: $e\n\n$st');
  }
}
