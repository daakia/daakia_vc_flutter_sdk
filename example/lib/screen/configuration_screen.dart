import 'package:daakia_vc_flutter_sdk/model/daakia_meeting_configuration.dart';
import 'package:example/utils/theme_color.dart';
import 'package:flutter/material.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  bool _includeMetadata = false;
  final List<MapEntry<TextEditingController, TextEditingController>>
      _metadataControllers = [];

  void _addMetadataField() {
    if (_metadataControllers.isNotEmpty) {
      final last = _metadataControllers.last;
      if (last.key.text.trim().isEmpty || last.value.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "Please fill in the current key-value before adding a new one.")),
        );
        return;
      }
    }

    setState(() {
      _metadataControllers.add(
        MapEntry(TextEditingController(), TextEditingController()),
      );
    });
  }

  void _removeMetadataField(int index) {
    setState(() {
      _metadataControllers[index].key.dispose();
      _metadataControllers[index].value.dispose();
      _metadataControllers.removeAt(index);
    });
  }

  DaakiaMeetingConfiguration _buildConfiguration() {
    Map<String, dynamic>? metadata;
    if (_includeMetadata) {
      metadata = {};
      for (final entry in _metadataControllers) {
        final key = entry.key.text.trim();
        final value = entry.value.text.trim();
        if (key.isNotEmpty) {
          metadata[key] = value;
        }
      }
    }

    return DaakiaMeetingConfiguration(
      metadata: metadata,
    );
  }

  @override
  void dispose() {
    for (var entry in _metadataControllers) {
      entry.key.dispose();
      entry.value.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ThemeColor.primaryThemeColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ThemeColor.primaryThemeColor),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text("Custom Configuration")),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      title: const Text("Include Metadata"),
                      value: _includeMetadata,
                      onChanged: (value) {
                        setState(() {
                          _includeMetadata = value;
                          if (!value) {
                            _metadataControllers.clear();
                          }
                        });
                      },
                    ),
                    if (_includeMetadata) ...[
                      const SizedBox(height: 10),
                      ..._metadataControllers.asMap().entries.map((entry) {
                        final index = entry.key;
                        final pair = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: pair.key,
                                  decoration: const InputDecoration(
                                    labelText: "Key",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: pair.value,
                                  decoration: const InputDecoration(
                                    labelText: "Value",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeMetadataField(index),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _addMetadataField,
                        icon: const Icon(Icons.add),
                        label: const Text("Add Metadata Field"),
                      ),
                    ],
                    const SizedBox(height: 80),
                    // Give room for the button at bottom
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final config = _buildConfiguration();
                      Navigator.pop(context, config);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text("Save Configuration"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
