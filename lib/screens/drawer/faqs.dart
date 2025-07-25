import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';

class FaqsScreen extends StatelessWidget {

  static const routeName = '/faqs';

  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I place an order?',
      'answer': 'To place an order, browse the menu, add items to your cart, and proceed to checkout.',
    },
    {
      'question': 'Can I track my delivery?',
      'answer': 'Yes, you can track your delivery in real-time from the orders section.',
    },
    {
      'question': 'How do I contact support?',
      'answer': 'You can contact support via the Help section in the app or by emailing support@example.com.',
    },
    {
      'question': 'What payment methods are accepted?',
      'answer': 'We accept credit cards, debit cards, and PayPal.',
    },
    {
      'question': 'Can I cancel my order?',
      'answer': 'Yes, you can cancel your order within 5 minutes of placing it from the orders section.',
    },
    // Add more fake FAQs as needed
  ];

   FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAQs'.tr(),
          style: GoogleFonts.sen(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDark ? const Color(0xff181F20) : Colors.white,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Card(
            color: isDark ? const Color(0xff23272A) : Colors.white,
            child: ExpansionTile(
              title: Text(
                faq['question']!.tr(),
                style: GoogleFonts.sen(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    faq['answer']!.tr(),
                    style: GoogleFonts.sen(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}