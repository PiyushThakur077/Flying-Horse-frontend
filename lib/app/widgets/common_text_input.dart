import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';

class CommonTextInput extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String)? onChanged;
  final bool showSegmentedTabs;
  final List<String>? segments;
  final Function(int)? onSegmentChanged;

  const CommonTextInput({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.showSegmentedTabs = false,
    this.segments,
    this.onSegmentChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFEEEEEE),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFFB8B8B8)),
            suffixIcon: showSegmentedTabs && segments != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SegmentedTab(
                      segments: segments!,
                      onSegmentChanged: onSegmentChanged,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class SegmentedTab extends StatefulWidget {
  final List<String> segments;
  final Function(int)? onSegmentChanged;

  const SegmentedTab({
    Key? key,
    required this.segments,
    this.onSegmentChanged,
  }) : super(key: key);

  @override
  _SegmentedTabState createState() => _SegmentedTabState();
}

class _SegmentedTabState extends State<SegmentedTab> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      segments: widget.segments.asMap().entries.map((entry) {
        return ButtonSegment<int>(
          value: entry.key,
          label: Text(entry.value),
        );
      }).toList(),
      selected: {_selectedIndex},
      showSelectedIcon: false,
      onSelectionChanged: (newSelection) {
        setState(() {
          _selectedIndex = newSelection.first;
        });
        if (widget.onSegmentChanged != null) {
          widget.onSegmentChanged!(_selectedIndex);
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return Colors.white;
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return Colors.black;
        }),
      ),
    );
  }
}
