import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SayyarApp());
}

class SayyarApp extends StatelessWidget {
  const SayyarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SAYYAR',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const PhoneLoginPage(),
    );
  }
}

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  String verificationId = '';
  bool otpSent = false;
  bool loading = false;

  Future<void> sendOTP() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty || !phone.startsWith('+')) {
      showMessage('Country code ke sath phone number likhein');
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (mounted) {
            showMessage('Login successful!');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          showMessage(e.message ?? 'OTP send nahi hua');
        },
        codeSent: (String id, int? resendToken) {
          verificationId = id;
          setState(() {
            otpSent = true;
          });
          showMessage('OTP aap ke phone par bhej diya gaya');
        },
        codeAutoRetrievalTimeout: (String id) {
          verificationId = id;
        },
      );
    } catch (e) {
      showMessage('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> verifyOTP() async {
    final code = otpController.text.trim();

    if (code.length != 6) {
      showMessage('6 digit OTP likhein');
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      showMessage('SAYYAR login successful!');
    } on FirebaseAuthException catch (e) {
      showMessage(e.message ?? 'OTP ghalat hai');
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_taxi,
                  size: 90,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 15),
                const Text(
                  'SAYYAR',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your Journey, Your Way',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 35),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '+9665XXXXXXXX',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: loading ? null : sendOTP,
                    child: Text(
                      loading ? 'Please wait...' : 'SEND OTP',
                    ),
                  ),
                ),
                if (otpSent) ...[
                  const SizedBox(height: 25),
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: 'Enter OTP',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: loading ? null : verifyOTP,
                      child: const Text('VERIFY OTP'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
