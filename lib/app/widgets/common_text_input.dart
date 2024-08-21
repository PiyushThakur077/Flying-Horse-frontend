import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/utils/text_style.dart';
import 'package:csc_picker/csc_picker.dart';

class CommonTextInput extends StatefulWidget {
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
  final VoidCallback? onTap;
  final TextEditingController? countryController;
  final TextEditingController? stateController;
  final TextEditingController? cityController;
  final Function(String countryCode, String stateCode, String city)? onAddressSelected;
  final bool required; 
  final bool isValid;
  final FormFieldValidator<String>? validator; // New validator parameter

  CommonTextInput({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.onTap,
    this.showSegmentedTabs = false,
    this.segments,
    this.selectedSegment,
    this.onSegmentSelected,
    this.readOnly = false,
    this.isCountryPicker = false,
    this.countryController,
    this.stateController,
    this.cityController,
    this.onAddressSelected,
    this.required = false, 
    this.isValid = true,
    this.validator, // Initialize the validator
  }) : super(key: key);

  @override
  State<CommonTextInput> createState() => _CommonTextInputState();
}

class _CommonTextInputState extends State<CommonTextInput> {
  late TextEditingController _controller;
  bool _showErrorBorder = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_validateField);
  }

  @override
  void dispose() {
    _controller.removeListener(_validateField);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _validateField() {
    setState(() {
      _showErrorBorder = widget.required && _controller.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: RichText(
            text: TextSpan(
              text: widget.labelText,
              style: AppTextStyle.mediumStyle(fontSize: 15, color: Color(0xff000000)),
              children: widget.required ? [TextSpan(text: ' *', style: TextStyle(color: Colors.red))] : [],
            ),
          ),
        ),
        const SizedBox(height: 6),
        if (widget.isCountryPicker)
          CSCPicker(
            flagState: CountryFlag.DISABLE,
            onCountryChanged: (country) {
              widget.countryController?.text = country;
              _validateField();  // Validate on change
            },
            onStateChanged: (state) {
              widget.stateController?.text = state ?? '';
              _validateField();  // Validate on change
              // Handle state selection logic
              String iso2StateCode = ''; // Assuming stateIsoMap logic
              if (widget.countryController?.text != null) {
                String countryCode = widget.countryController!.text;
                widget.onAddressSelected?.call(
                  countryCode,
                  iso2StateCode.isNotEmpty ? iso2StateCode : 'Unknown',
                  widget.cityController?.text ?? '',
                );
              }
            },
            onCityChanged: (city) {
              widget.cityController?.text = city ?? '';
              _validateField();  // Validate on change
              // Handle city selection logic
              if (widget.countryController?.text != null &&
                  widget.stateController?.text != null) {
                String countryCode = widget.countryController!.text;
                String stateCode = ''; // Assuming stateIsoMap logic
                widget.onAddressSelected?.call(
                  countryCode,
                  stateCode,
                  widget.cityController?.text ?? '',
                );
              }
            },
            showStates: true,
            showCities: true,
            layout: Layout.vertical,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              color: const Color(0xFFEEEEEE),
              border: Border.all(color: _showErrorBorder ? Colors.red : Colors.grey.shade300),
            ),
            disabledDropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              border: Border.all(color: Colors.grey.shade300),
              color: const Color(0xFFEEEEEE),
            ),
            countrySearchPlaceholder: "Search Country",
            stateSearchPlaceholder: "Search State",
            citySearchPlaceholder: "Search City",
            countryFilter: const [
              CscCountry.Canada,
              CscCountry.United_States,
              CscCountry.Mexico,
            ],
          )
        else
          Container(
            width: double.infinity,
            height: 60,
            child: TextFormField(
              controller: _controller,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              validator: widget.validator, 
              onChanged: (value) {
                if (widget.onChanged != null) widget.onChanged!(value);
                _validateField();
              },
              
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFEEEEEE),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: _showErrorBorder ? BorderSide(color: Colors.red) : BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: _showErrorBorder ? BorderSide(color: Colors.red) : BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: _showErrorBorder ? BorderSide(color: Colors.red) : BorderSide.none,
                ),
                
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Color(0xFFB8B8B8)),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                suffixIcon: widget.showSegmentedTabs && widget.segments != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          height: 30, // Smaller height
                          child: SegmentedTab(
                            segments: widget.segments!,
                            selectedSegment: widget.selectedSegment,
                            onSegmentSelected: widget.onSegmentSelected,
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
