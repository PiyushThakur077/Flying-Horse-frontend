import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/utils/text_style.dart';

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
  final VoidCallback? onTap;
  final bool required;
  final bool isValid;
  final bool isDisabled;
  final FormFieldValidator<String>? validator;
  final double? height;

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
    this.required = false,
      this.isDisabled = false, 
    this.isValid = true,
    this.validator,
    this.height,
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
              style: AppTextStyle.mediumStyle(
                  fontSize: 15, color: Color(0xff000000)),
              children: widget.required
                  ? [TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
                  : [],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: widget.height ?? 75,
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
            style: TextStyle(
              color: widget.readOnly ? Colors.grey : Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFEEEEEE),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: _showErrorBorder ? Colors.red : Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: _showErrorBorder ? Colors.red : Colors.grey.shade300,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.red, // Red border for error state
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.red, // Red border for focused error state
                ),
              ),
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Color(0xFFB8B8B8)),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 20.0,
              ),
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
  final bool readOnly; // New property

  const SegmentedTab({
    Key? key,
    required this.segments,
    this.selectedSegment,
    this.onSegmentSelected,
    this.readOnly = false, // Default is false
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
  void didUpdateWidget(SegmentedTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the _selectedSegment if the selectedSegment prop changes
    if (widget.selectedSegment != oldWidget.selectedSegment) {
      _selectedSegment = widget.selectedSegment ?? widget.segments[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30, // Smaller height
      child: ToggleButtons(
        isSelected: widget.segments
            .map((segment) => segment == _selectedSegment)
            .toList(),
        onPressed: widget.readOnly ? null : (index) {
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


