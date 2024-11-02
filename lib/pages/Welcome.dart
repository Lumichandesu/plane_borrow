import 'package:flutter/material.dart';
import 'Loginpage.dart';

class Welcomepage extends StatelessWidget {
  const Welcomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/airplane.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            padding: const EdgeInsets.only(left: 25, top: 200),
            child: const Text(
              'SkyChauffeur',
              style: TextStyle(
                fontSize: 55,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 208, top: 550),
            child: const Text(
              'Fly in style with SkyChauffeur. ',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 30, top: 570),
            child: const Text(
              'Rent your private jet and pilot for a luxury travel experience. ',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 30, top: 590),
            child: const Text(
              'Wherever you’re going, we’ll take you there in comfort and elegance. ',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
          Center(
            child: Container(
                padding: const EdgeInsets.only(top: 550),
                child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Loginpage()),
                      );
                    },
                    style:
                        FilledButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text("     START !     "))),
          )
        ],
      ),
    );
  }
}
