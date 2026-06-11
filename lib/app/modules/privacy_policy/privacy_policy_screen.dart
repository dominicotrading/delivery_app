import 'package:flutter/material.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const String routeName = "/privacy-policy-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: lightColor,
        title: Text(
          "Privacy Policy",
          style: lightNormalTextStyle(FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              "Introduction",
              "Welcome to Marocsie's Privacy Policy. This document explains how we collect, use, and protect your personal information when you use our telemedicine platform.",
            ),
            _buildSection(
              "Information We Collect",
              "We collect information that you provide directly to us, including:\n\n"
              "• Personal identification information (Name, email address, phone number)\n"
              "• Medical information and history\n"
              "• Payment information\n"
              "• Communication data\n"
              "• Device and usage information",
            ),
            _buildSection(
              "How We Use Your Information",
              "We use the collected information for:\n\n"
              "• Providing telemedicine services\n"
              "• Processing payments\n"
              "• Sending appointment reminders\n"
              "• Improving our services\n"
              "• Communicating with you about our services",
            ),
            _buildSection(
              "Data Security",
              "We implement appropriate security measures to protect your personal information. This includes:\n\n"
              "• Encryption of sensitive data\n"
              "• Secure data storage\n"
              "• Regular security assessments\n"
              "• Access controls and authentication",
            ),
            _buildSection(
              "Data Sharing",
              "We may share your information with:\n\n"
              "• Healthcare providers\n"
              "• Payment processors\n"
              "• Service providers\n"
              "• Legal authorities when required by law",
            ),
            _buildSection(
              "Your Rights",
              "You have the right to:\n\n"
              "• Access your personal information\n"
              "• Correct inaccurate data\n"
              "• Request deletion of your data\n"
              "• Opt-out of marketing communications\n"
              "• File a complaint",
            ),
            _buildSection(
              "Cookies and Tracking",
              "We use cookies and similar tracking technologies to improve your experience on our platform. You can control cookie settings through your browser preferences.",
            ),
            _buildSection(
              "Children's Privacy",
              "Our services are not intended for children under 13. We do not knowingly collect personal information from children under 13.",
            ),
            _buildSection(
              "Changes to Privacy Policy",
              "We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page.",
            ),
            _buildSection(
              "Contact Us",
              "If you have any questions about this Privacy Policy, please contact us at:\n\n"
              "Email: semir@marcoci6311.com\n"
              "Phone: +251967888444 | +251911223560\n"
              "Address: Friendship Business Center #406, Airport Road , Addis Ababa, Ethiopia",
            ),
            SizedBox(height: 20),
            Text(
              "Last updated: ${DateTime.now().year}",
              style: smallDarkTextStyle,
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: darkNormalTextStyle(FontWeight.bold).copyWith(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: smallDarkTextStyle.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
} 