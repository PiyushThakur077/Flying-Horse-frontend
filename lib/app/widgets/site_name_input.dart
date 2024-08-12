import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SiteNameInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  const SiteNameInput({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.suggestions,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        TypeAheadField<String>(
          suggestionsCallback: (pattern) async {
            return Future.value(
              suggestions.where((item) => item
                  .toLowerCase()
                  .contains(pattern.toLowerCase()))
              .toList(),
            );
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          onSelected: (suggestion) {
            onSelected(suggestion);
            controller.text = suggestion;
          },
        ),
      ],
    );
  }
}