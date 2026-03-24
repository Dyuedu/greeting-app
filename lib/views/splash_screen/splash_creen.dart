import 'dart:async';

import 'package:flutter/material.dart';
import 'package:greeting_app/core/theme/tet_colors.dart';
import 'package:greeting_app/core/widgets/animated_reveal.dart';
import 'package:greeting_app/views/contact_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ContactListScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AnimatedReveal(
                delay: Duration(milliseconds: 120),
                beginOffset: Offset(0, 0.08),
                child: Text(
                  "MÃ ĐÁO THÀNH CÔNG",
                  style: TextStyle(
                    color: TetColors.prosperityGold,
                    fontSize: 30,
                    fontFamily: 'ThuPhap',
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              AnimatedReveal(
                delay: const Duration(milliseconds: 280),
                beginOffset: const Offset(0, 0.04),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.92, end: 1),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) =>
                      Transform.scale(scale: value, child: child),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logo/logo.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const AnimatedReveal(
                delay: Duration(milliseconds: 420),
                beginOffset: Offset(0, 0.05),
                child: Text(
                  'Kính chúc an khang, vạn sự như ý',
                  style: TextStyle(
                    color: TetColors.prosperityGoldLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
