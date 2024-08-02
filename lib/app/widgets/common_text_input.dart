import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/utils/text_style.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';

class CommonTextInput extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String)? onChanged;
  final bool showSegmentedTabs;
  final List<String>? segments;
  final String? selectedSegment;
  final Function(String)? onSegmentSelected;
  final bool readOnly;
  final bool isCountryPicker;
  final TextEditingController? countryController;
  final TextEditingController? stateController;
  final TextEditingController? cityController;

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
    this.selectedSegment,
    this.onSegmentSelected,
    this.readOnly = false,
    this.isCountryPicker = false,
    this.countryController,
    this.stateController,
    this.cityController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            labelText,
            style: AppTextStyle.mediumStyle(
                fontSize: 15, color: Color(0xff000000)),
          ),
        ),
        const SizedBox(height: 6),
        if (isCountryPicker)
          CountryStateCityPicker(
            
            country: countryController!,
            state: stateController!,
            city: cityController!,
            dialogColor: Colors.grey.shade200,
            textFieldDecoration: InputDecoration(
              fillColor: const Color(0xFFEEEEEE),
              filled: true,
              suffixIcon: const Icon(Icons.arrow_drop_down),
              border: InputBorder.none,
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
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            ),
          )
        else
          Container(
            width: double.infinity,
            height: 50,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              onChanged: onChanged,
              readOnly: readOnly,
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
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                suffixIcon: showSegmentedTabs && segments != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          height: 30, // Smaller height
                          child: SegmentedTab(
                            segments: segments!,
                            selectedSegment: selectedSegment,
                            onSegmentSelected: onSegmentSelected,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
      ],
    );
  }
}

class SegmentedTab extends StatefulWidget {
  final List<String> segments;
  final String? selectedSegment;
  final Function(String)? onSegmentSelected;

  const SegmentedTab({
    Key? key,
    required this.segments,
    this.selectedSegment,
    this.onSegmentSelected,
  }) : super(key: key);

  @override
  _SegmentedTabState createState() => _SegmentedTabState();
}

class _SegmentedTabState extends State<SegmentedTab> {
  late String _selectedSegment;

  @override
  void initState() {
    super.initState();
    _selectedSegment = widget.selectedSegment ?? widget.segments[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30, // Smaller height
      child: ToggleButtons(
        isSelected: widget.segments
            .map((segment) => segment == _selectedSegment)
            .toList(),
        onPressed: (index) {
          setState(() {
            _selectedSegment = widget.segments[index];
          });
          if (widget.onSegmentSelected != null) {
            widget.onSegmentSelected!(_selectedSegment);
          }
        },
        borderRadius: BorderRadius.circular(15.0),
        fillColor: AppColors.primary,
        selectedColor: Colors.white,
        color: Colors.black,
        constraints: BoxConstraints(minHeight: 30, minWidth: 50),
        children: widget.segments
            .map((segment) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7.0, vertical: 5.0),
                  child: Text(segment, style: TextStyle(fontSize: 14)),
                ))
            .toList(),
      ),
    );
  }
}
