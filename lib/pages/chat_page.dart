import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perplexity/services/chat_web_service.dart';
import 'package:perplexity/theme/colors.dart';
import 'package:perplexity/widgets/answer_section.dart';
import 'package:perplexity/widgets/search_bar_button.dart';
import 'package:perplexity/widgets/side_bar.dart';
import 'package:perplexity/widgets/sources_section.dart';

class ChatPage extends StatefulWidget {
  final String question;
  const ChatPage({super.key, required this.question});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController queryController = TextEditingController();
  String _currentQuestion = ''; // Thêm biến state để lưu câu hỏi hiện tại

  @override
  void initState() {
    super.initState();
    _currentQuestion = widget.question;
    ChatWebService().chat(widget.question);
  }

  void _submitNewQuestion() {
    final question = queryController.text.trim();
    if (question.isNotEmpty) {
      queryController.clear(); // Xóa ô nhập
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatPage(question: question),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          kIsWeb ? const SideBar() : const SizedBox(),
          kIsWeb ? const SizedBox(width: 100) : const SizedBox(),
          Expanded(
            child: Column(
              children: [
                // Nội dung cuộn được
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Câu hỏi hiển thị
                        Text(
                          _currentQuestion,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const SourcesSection(),
                        const SizedBox(height: 24),
                        const AnswerSection(),
                        const SizedBox(
                            height:
                                80), // để tạo khoảng cách tránh che nội dung bởi input
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 700,
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.searchBar,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.searchBarBorder,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextField(
                          controller: queryController,
                          decoration: const InputDecoration(
                            hintText: 'Ask anything...',
                            hintStyle: TextStyle(color: AppColors.textGrey),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: (_) => _submitNewQuestion(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const SearchBarButton(
                              icon: Icons.auto_awesome_outlined,
                              text: 'Search',
                            ),
                            const SizedBox(width: 26),
                            const SearchBarButton(
                              icon: Icons.analytics_rounded,
                              text: 'Research',
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _submitNewQuestion,
                              child: Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  color: AppColors.submitButton,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.background,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          kIsWeb
              ? const SizedBox(
                  width: 100,
                  child: Placeholder(
                    strokeWidth: 0,
                    color: AppColors.background,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
