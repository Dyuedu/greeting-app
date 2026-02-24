import 'dart:async';

import 'package:flutter/material.dart';
import 'package:greeting_app/core/theme/tet_colors.dart';
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
    Timer(Duration(seconds: 2), () {
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
              Text(
                "MÃ ĐÁO THÀNH CÔNG",
                style: TextStyle(
                  color: TetColors.prosperityGold,
                  fontSize: 30,
                  fontFamily: 'ThuPhap',
                  letterSpacing: 1.5,
                ),
              ),
              ClipOval(
                child: Image.asset(
                  'assets/logo/logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              // Chữ tiêu đề
            ],
          ),
        ),
      ),
    );
  }
}
