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
                    title: 'Tendon Glides',
                    description: '30 - 60 seconds each',
                    videoPath: 'assets/break_vids/break_vid1.mp4',
                  ),
                  const SizedBox(height: 16),
                  VideoCard(
                    title: 'Nerve Glides',
                    description: '30 - 60 seconds each',
                    videoPath: 'assets/break_vids/break_vid2.mp4',
                  ),
                  const SizedBox(height: 16),
                  VideoCard(
                    title: 'Thoracic Rotation',
                    description: '1 - 2 sets; 10 - 12 reps each side',
                    videoPath: 'assets/break_vids/break_vid3.mp4',
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