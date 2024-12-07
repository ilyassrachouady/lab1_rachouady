import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('About', style: TextStyle(color: Colors.white)),
        backgroundColor: isDarkMode ? const Color(0xFF3700B3) : const Color(0xFF6200EA),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode 
              ? [Colors.black87, Colors.grey[900]!]
              : [Colors.blue[50]!, Colors.blue[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            // Animated COVID Icon
            Center(
              child: AnimatedIcon(
                icon: AnimatedIcons.event_add,
                progress: const AlwaysStoppedAnimation(0.5), // Halfway to show animation partially
                size: 60,
                color: isDarkMode ? Colors.orange[300] : Colors.red[600],
              ),
            ),
            const SizedBox(height: 20),

            // App Description Card
            Card(
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      "Flutter COVID Tracker",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "This app helps you stay updated with COVID information and tools. "
                      "You can track cases, receive health tips, and chat with our Emsi Chatbot.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // COVID Awareness Tips Card
            Card(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: isDarkMode ? Colors.orange : Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          "COVID Awareness Tips",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.orange : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "• Maintain social distancing.\n"
                      "• Wash your hands regularly.\n"
                      "• Wear a mask in crowded places.\n"
                      "• Stay updated with official health information.",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Developer Information
            Card(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.developer_mode, color: isDarkMode ? Colors.greenAccent : Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          "Developed by Ilyass Rachouady",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.greenAccent : Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "This app is built with Flutter to demonstrate modern UI design and functionality. "
                      "Feel free to explore more features!",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
