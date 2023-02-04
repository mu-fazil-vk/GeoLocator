import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 47, 43, 43),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 47, 43, 43),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'GeoLocator',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            Image.asset(
              'asset/logo.png',
              width: 50,
              height: 50,
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: Text('No result found!...', style: TextStyle(color: Colors.white),),
          )
        ],
      ),
    );
  }
}
