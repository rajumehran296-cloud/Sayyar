import 'package:flutter/material.dart';

void main() {
  runApp(const SayyarApp());
}

class SayyarApp extends StatelessWidget {
  const SayyarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SAYYAR',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF101010),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pickupController = TextEditingController();
  final destinationController = TextEditingController();

  String language = 'English';

  @override
  void dispose() {
    pickupController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'SAYYAR',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                language = value;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'English', child: Text('English')),
              PopupMenuItem(value: 'العربية', child: Text('العربية')),
              PopupMenuItem(value: 'اردو', child: Text('اردو')),
            ],
            icon: const Icon(Icons.language, color: Color(0xFFD4AF37)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 25),
            const Icon(
              Icons.local_taxi,
              size: 85,
              color: Color(0xFFD4AF37),
            ),
            const SizedBox(height: 15),
            const Text(
              'Your Ride, Your Way',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome to SAYYAR - Riyadh',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 35),
            TextField(
              controller: pickupController,
              decoration: InputDecoration(
                labelText: 'Pickup location',
                prefixIcon: const Icon(Icons.my_location),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: destinationController,
              decoration: InputDecoration(
                labelText: 'Where are you going?',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD4AF37)),
              ),
              child: const Column(
                children: [
                  Text(
                    'SAYYAR RIDE',
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Fare will be calculated when booking is connected.'),
                ],
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  if (pickupController.text.isEmpty ||
                      destinationController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter pickup and destination'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Booking feature will be connected soon'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'BOOK YOUR RIDE',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Language: $language',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFD4AF37)),
            ),
          ],
        ),
      ),
    );
  }
}
