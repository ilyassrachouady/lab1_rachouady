import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:dialogflow_flutter/language.dart';
import 'package:flutter/material.dart';

class EmsiChatbotPage extends StatefulWidget {
   const EmsiChatbotPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmsiChatbotPageState createState() => _EmsiChatbotPageState();
}

class _EmsiChatbotPageState extends State<EmsiChatbotPage> {
  late DialogFlow dialogflow;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    _loadDialogflow();
  }

  // Load the JSON key and initialize Dialogflow
  Future<void> _loadDialogflow() async {
    try {
      AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/myappflutter-440612-9ed7b0039eab.json").build();
      dialogflow = DialogFlow(authGoogle: authGoogle, language: Language.english);
      // Using a logging framework is recommended over print in production
      debugPrint("Dialogflow initialized successfully.");
    } catch (e) {
      debugPrint("Error initializing Dialogflow: $e");
    }
  }

  // Method to send a message to Dialogflow and receive a response
  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "message": message});
      _controller.clear();
    });

    try {
      AIResponse response = await dialogflow.detectIntent(message);
      // Print the response object for debugging
      debugPrint("Response from Dialogflow: ${response.toString()}");

      // Check if the response contains a message
      String? botResponse = response.getMessage();
      if (botResponse!.isNotEmpty) {
        setState(() {
          messages.add({"sender": "bot", "message": botResponse});
        });
      } else {
        // Provide a default response if no message is returned
        setState(() {
          messages.add({"sender": "bot", "message": "Sorry, I couldn't understand that."});
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"sender": "bot", "message": "Error: Unable to get response"});
      });
      debugPrint("Error in _sendMessage: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMSI Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message["sender"] == "user";
                return ListTile(
                  title: Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message["message"]!,
                        style: TextStyle(color: isUserMessage ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_controller.text.trim());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
