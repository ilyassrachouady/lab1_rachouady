import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruit Classifier'),
        backgroundColor: isDarkMode ? Colors.green[800] : Colors.green,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [Colors.green[900]!, Colors.green[800]!]
                      : [Colors.green[100]!, Colors.green[400]!],
                ),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/profile.jpeg'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ilyass Rachouady',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Logged In',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.pushNamed(context, '/history');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Smoothies'),
              onTap: () {
                Navigator.pushNamed(context, '/ingredient_recognition');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Handle logout logic here
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Colors.green[900]!, Colors.green[800]!]
                        : [Colors.green[100]!, Colors.green[300]!],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.apple,
                      size: 50,
                      color: isDarkMode ? Colors.orange : Colors.green[700],
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome to Fruit Classifier",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color:
                                  isDarkMode ? Colors.orange : Colors.green[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Easily identify fruits using AI. Start exploring now!",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Quick Access Cards
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                children: [
                  _buildQuickAccessCard(
                    context,
                    Icons.apple,
                    "Fruit Classifier",
                    '/fruit_classifier',
                    isDarkMode,
                  ),
                  _buildQuickAccessCard(
                    context,
                    Icons.info,
                    "About",
                    '/about',
                    isDarkMode,
                  ),
                  _buildQuickAccessCard(
                    context,
                    Icons.settings,
                    "Settings",
                    '/settings',
                    isDarkMode,
                  ),
                  _buildQuickAccessCard(
                    context,
                    Icons.help_outline,
                    "Help",
                    '/help',
                    isDarkMode,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Fun Facts Section
              Card(
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Fruit Fun Facts",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  isDarkMode ? Colors.orange : Colors.green[700],
                            ),
                          ),
                          Icon(
                            Icons.local_florist,
                            color:
                                isDarkMode ? Colors.orange : Colors.green[700],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Did you know? Bananas are berries, but strawberries aren't!",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Smoothie Suggestions Section
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Colors.purple[900]!, Colors.purple[700]!]
                        : [Colors.purple[100]!, Colors.purple[300]!],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Smoothie Suggestions",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode ? Colors.white : Colors.purple[800],
                      ),
                    ),
                    const SizedBox(height: 15),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      children: [
                        _buildSmoothieCard(
                          context,
                          "Berry Blast",
                          "Strawberries, Blueberries, Bananas",
                          'assets/images/smoothie_1.jpg',
                          isDarkMode,
                        ),
                        _buildSmoothieCard(
                          context,
                          "Tropical Dream",
                          "Mango, Pineapple, Coconut",
                          'assets/images/smoothie_2.jpg',
                          isDarkMode,
                        ),
                        _buildSmoothieCard(
                          context,
                          "Green Energy",
                          "Spinach, Apple, Banana",
                          'assets/images/smoothie_3.jpg',
                          isDarkMode,
                        ),
                        _buildSmoothieCard(
                          context,
                          "Citrus Twist",
                          "Orange, Grapefruit, Lemon",
                          'assets/images/smoothie_4.jpg',
                          isDarkMode,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessCard(BuildContext context, IconData icon,
      String title, String route, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        color: isDarkMode ? Colors.green[700] : Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: isDarkMode ? Colors.white : Colors.green[700],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.green[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmoothieCard(BuildContext context, String title, String description,
      String imagePath, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        // Add action to navigate to smoothie detail page
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.purple[700],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white70 : Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
