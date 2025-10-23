import 'package:flutter/material.dart';

import '../base_input.dart';
import 'suggestions_list.dart';

class SuggestionsInputApp extends StatefulWidget {
  final String label;
  final String? value;
  final Function(String)? onChanged;
  final List<String> suggestions;
  final String? Function(String?)? validator;

  const SuggestionsInputApp({
    super.key,
    required this.label,
    this.value,
    this.onChanged,
    required this.suggestions,
    this.validator,
  });

  @override
  State<SuggestionsInputApp> createState() => SuggestionsInputAppState();
}

class SuggestionsInputAppState extends State<SuggestionsInputApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputStyles.getInputDecoration(widget.label).copyWith(
            suffixIcon: _filteredSuggestions.isNotEmpty
                ? GestureDetector(
                    onTap: _toggleSuggestions,
                    child: Icon(
                      _showSuggestions
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : null,
          ),
          onChanged: (value) {
            widget.onChanged?.call(value);
            _filterSuggestions(value);
          },
          validator: widget.validator,
        ),
        if (_showSuggestions && _filteredSuggestions.isNotEmpty)
          SuggestionsList(
            suggestions: _filteredSuggestions,
            animationController: _animationController,
            fadeAnimation: _fadeAnimation,
            slideAnimation: _slideAnimation,
            onSuggestionSelected: _selectSuggestion,
          ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value ?? '';

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _focusNode.addListener(_onFocusChanged);
  }

  void _filterSuggestions(String query) {
    setState(() {
      _filteredSuggestions = widget.suggestions
          .where(
            (suggestion) =>
                suggestion.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  void _hideSuggestions() {
    if (_showSuggestions) {
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showSuggestions = false;
          });
        }
      });
    }
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      setState(() {
        _filteredSuggestions = widget.suggestions;
        if (_filteredSuggestions.isNotEmpty) {
          _showSuggestions = true;
          _animationController.forward();
        }
      });
    } else {
      _hideSuggestions();
    }
  }

  void _selectSuggestion(String suggestion) {
    _controller.text = suggestion;
    widget.onChanged?.call(suggestion);
    _focusNode.unfocus();
    _hideSuggestions();
  }

  void _toggleSuggestions() {
    setState(() {
      if (_showSuggestions) {
        _hideSuggestions();
      } else {
        _filteredSuggestions = widget.suggestions;
        if (_filteredSuggestions.isNotEmpty) {
          _showSuggestions = true;
          _animationController.forward();
        }
      }
    });
  }
}
