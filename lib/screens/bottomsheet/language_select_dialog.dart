import 'package:flutter/material.dart';

import '../../model/language_model.dart';

class LanguageSelectDialog extends StatefulWidget {
  final List<LanguageModel> languages;
  final Function(LanguageModel) onLanguageSelected;

  const LanguageSelectDialog({
    required this.languages,
    required this.onLanguageSelected,
    super.key,
  });

  @override
  State<LanguageSelectDialog> createState() => _LanguageSelectDialogState();
}

class _LanguageSelectDialogState extends State<LanguageSelectDialog> {
  late TextEditingController _searchController;
  late List<LanguageModel> _filteredLanguages;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredLanguages = widget.languages;
  }

  void _filterLanguages(String query) {
    setState(() {
      _filteredLanguages = widget.languages
          .where((lang) =>
      lang.language?.toLowerCase().contains(query.toLowerCase()) ??
          false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // White background
      title: const Text(
        'Select Language',
        style: TextStyle(color: Colors.black), // Black text
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Prevent full-screen expansion
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search languages...',
              hintStyle: const TextStyle(color: Colors.black54), // Subtle hint text
              prefixIcon: const Icon(Icons.search, color: Colors.black), // Black icon
              filled: true,
              fillColor: Colors.grey[200], // Light grey input field
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.black), // Black text in input field
            onChanged: _filterLanguages,
          ),
          const SizedBox(height: 10),
          _filteredLanguages.isEmpty
              ? const Center(
            child: Text(
              'No languages found',
              style: TextStyle(color: Colors.black), // Black text
            ),
          )
              : Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredLanguages.length,
              itemBuilder: (context, index) {
                final language = _filteredLanguages[index];
                return ListTile(
                  title: Text(
                    language.language ?? '',
                    style: const TextStyle(color: Colors.black), // Black text
                  ),
                  onTap: () {
                    widget.onLanguageSelected(language);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
