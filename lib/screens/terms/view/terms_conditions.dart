import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:flutter/material.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  // Placeholder text used to populate the terms sections
  static const String _dummyText = '''
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages,

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            CommonUi.setPngIcon("left_vector"),
            height: 15,
            width: 15,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Renders multiple terms sections, first one has a visible title
              _buildCardSection("Terms & Conditions", _dummyText),
              _buildCardSection("", _dummyText),
              _buildCardSection("", _dummyText),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardSection(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Conditionally renders the section
          if (title.isNotEmpty)
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.6,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (title.isNotEmpty) const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
