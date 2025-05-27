import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perplexity/pages/chat_page.dart';
import 'package:perplexity/services/chat_web_service.dart';
import 'package:perplexity/theme/colors.dart';
import 'package:perplexity/widgets/search_bar_button.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  final queryController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    queryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(
              'Tra không ra thì là do mày hỏi ngu :v,',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'hoặc tao chưa cập nhật -_-',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        Container(
          width: 700,
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
                    hintStyle: TextStyle(
                      color: AppColors.textGrey,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
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
                    const SizedBox(
                      width: 26,
                    ),
                    const SearchBarButton(
                      icon: Icons.analytics_rounded,
                      text: 'Research',
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        ChatWebService().chat(queryController.text.trim());
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                                question: queryController.text.trim())));
                      },
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
    );
  }
}
