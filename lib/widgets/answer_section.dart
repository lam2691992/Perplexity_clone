import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:perplexity/services/chat_web_service.dart';
import 'package:perplexity/theme/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnswerSection extends StatefulWidget {
  const AnswerSection({super.key});

  @override
  State<AnswerSection> createState() => _AnswerSectionState();
}

class _AnswerSectionState extends State<AnswerSection> {
  bool isLoading = true;
  String fullResponse = '';

  @override
  void initState() {
    super.initState();
    ChatWebService().contentStream.listen((data) {
      if (isLoading) {
        fullResponse = "";
      }

      setState(() {
        fullResponse += data['data'];
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '------',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Skeletonizer(
          enabled: isLoading,
          child: isLoading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: double.infinity,
                      height: 20,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                )
              : Markdown(
                  data: fullResponse,
                  shrinkWrap: true,
                  styleSheet:
                      MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    codeblockDecoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    code: const TextStyle(fontSize: 16),
                    p: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
        ),
      ],
    );
  }
}
