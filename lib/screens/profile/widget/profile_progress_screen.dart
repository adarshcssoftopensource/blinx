import 'package:flutter/material.dart';

import '../../../utils/screens/string_constants.dart';

class ProfileProgressScreen extends StatelessWidget {
  const ProfileProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.profileProgress),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Center(child: Text(AppConstants.profileProgressScreen)),
    );
  }
}
