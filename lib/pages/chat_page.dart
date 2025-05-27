import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perplexity/theme/colors.dart';
import 'package:perplexity/widgets/answer_section.dart';
import 'package:perplexity/widgets/side_bar.dart';
import 'package:perplexity/widgets/sources_section.dart';

class ChatPage extends StatelessWidget {
  final String question;
  const ChatPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          kIsWeb ? const SideBar() : const SizedBox(),
          kIsWeb
              ? const SizedBox(
                  width: 100,
                )
              : const SizedBox(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question,
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const SourcesSection(),
                    const SizedBox(
                      height: 24,
                    ),
                    const AnswerSection(),
                  ],
                ),
              ),
            ),
          ),
          kIsWeb ? const SizedBox(
            width: 100,
            child: Placeholder(
              strokeWidth: 0,
              color: AppColors.background,
            ),
          ) : const SizedBox(),
        ],
      ),
    );
  }
}
