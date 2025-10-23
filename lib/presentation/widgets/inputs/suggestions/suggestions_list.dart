import 'package:flutter/material.dart';

class SuggestionsList extends StatelessWidget {
  final List<String> suggestions;
  final AnimationController animationController;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Function(String) onSuggestionSelected;

  const SuggestionsList({
    super.key,
    required this.suggestions,
    required this.animationController,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      suggestion,
                      style: const TextStyle(fontSize: 14),
                    ),
                    onTap: () => onSuggestionSelected(suggestion),
                    hoverColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
