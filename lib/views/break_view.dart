import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/videocard.dart';



class BreakView extends StatelessWidget {
  const BreakView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMM dd, yyyy').format(DateTime.now()).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Break \nTime',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                children: [
                  const SizedBox(height: 24),
                  VideoCard(
                    title: 'Relaxing Nature Sounds',
                    description: 'Take a peaceful break with calming forest sounds and bird songs',
                    videoPath: 'assets/break_vids/break_vid1.mp4',
                  ),
                  const SizedBox(height: 16),
                  VideoCard(
                    title: '5-Minute Stretching',
                    description: 'Quick desk exercises to refresh your body and mind',
                    videoPath: 'assets/break_vids/break_vid1.mp4',
                  ),
                  const SizedBox(height: 16),
                  VideoCard(
                    title: 'Breathing Exercise',
                    description: 'Simple breathing techniques to reduce stress and improve focus',
                    videoPath: 'assets/break_vids/break_vid1.mp4',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
              
              // Add more widgets here
            ],
          ),
        ),
      ),
    );
  }
}