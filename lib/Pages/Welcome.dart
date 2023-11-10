import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo.png', width: 100, height: 100),
            const SizedBox(height: 20),
            // Text
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Come one, come all to your financial management or projection tool',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Next button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFF0F8FF),
    );
  }
}
