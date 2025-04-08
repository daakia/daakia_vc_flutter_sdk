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
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevent full expansion
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search languages...',
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: _filterLanguages,
            ),
            const SizedBox(height: 10),
            _filteredLanguages.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'No languages found',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _filteredLanguages.length,
                      itemBuilder: (context, index) {
                        final language = _filteredLanguages[index];
                        return ListTile(
                          title: Text(
                            language.language ?? '',
                            style: const TextStyle(color: Colors.black),
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
      ),
    );
  }
}
