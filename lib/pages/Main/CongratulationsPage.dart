// ignore_for_file: file_names

import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:flutter/material.dart';

class OurCongratulations extends StatefulWidget {
  const OurCongratulations({super.key});

  @override
  State<OurCongratulations> createState() => _OurCongratulationsState();
}

class _OurCongratulationsState extends State<OurCongratulations> {
  ConfettiController confettiController = ConfettiController();

  @override
  void initState() {
    super.initState();

    confettiController.duration = const Duration(seconds: 5);
    confettiController.play();
  }

  @override
  void dispose() {
    super.dispose();

    confettiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 0),
              const Text(
                "Thanks for donating!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 0),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  alignment: Alignment.center,
                  height: 75,
                  decoration: BoxDecoration(
                    color: ourPrimaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              ConfettiWidget(
                confettiController: confettiController,
                blastDirection: -pi / 2,
                colors: const [
                  ourPrimaryColor,
                  startingColor,
                  Colors.teal,
                  Colors.green,
                ],
                gravity: 0.05,
                emissionFrequency: 0.3,
                blastDirectionality: BlastDirectionality.explosive,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
