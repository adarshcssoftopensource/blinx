import 'package:blinx_mobile/widgets/custom_button.dart';
import 'package:blinx_mobile/widgets/custom_toggle_switch.dart';
import 'package:flutter/material.dart';

class DataPreferenceScreen extends StatefulWidget {
  const DataPreferenceScreen({super.key});

  @override
  State<DataPreferenceScreen> createState() => _DataPreferenceScreenState();
}

class _DataPreferenceScreenState extends State<DataPreferenceScreen> {
  bool profileSearch = true;
  bool publicSpacesAlerts = true;
  String selectedOption = "Full name";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Data Preference",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Show my name on posts",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Choose how your name appears on your post and comments.",
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),

                    const SizedBox(height: 14),

                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _selectionButton("Full name", 0),
                            _selectionButton("Username", 1),
                            _selectionButton("Anonymous", 2),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
                    Divider(color: Colors.grey.shade300, height: 1),

                    const SizedBox(height: 12),

                    CustomToggleSwitch(
                      title: "Profile Searchability",
                      subtitle: "Allow others to find your profile",
                      value: publicSpacesAlerts,
                      onChanged: (v) => setState(() => publicSpacesAlerts = v),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: Colors.grey.shade300, height: 1),
                    const SizedBox(height: 12),
                    const Text(
                      "Account Management",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Permanently delete your account and all associated data. "
                      "This action cannot be undone.",
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: CustomButton(
                text: "Delete Account",
                onPressed: () {},
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectionButton(String label, int index) {
    bool isSelected = selectedOption == label;

    return GestureDetector(
      onTap: () => setState(() => selectedOption = label),
      child: Container(
        width: 90,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(index == 0 ? 8 : 0),
            right: Radius.circular(index == 2 ? 8 : 0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
