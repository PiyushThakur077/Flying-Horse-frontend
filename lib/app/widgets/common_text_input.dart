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
          padding: EdgeInsets.symmetric(horizontal: 8),
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
            readOnly: widget.readOnly &&
                !widget.showSegmentedTabs, // Conditional readOnly
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFEEEEEE),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),

                borderSide: BorderSide(
                  color: _showErrorBorder ? Colors.red : Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),

                borderSide: BorderSide(
                  color: _showErrorBorder ? Colors.red : Colors.grey.shade300,
                ),
              ),
              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),

                borderSide: BorderSide(
                  color: Colors.red, // Red border for error state
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),

                borderSide: BorderSide(
                  color: Colors.red, // Red border for focused error state
                ),
              ),
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Color(0xFFB8B8B8)),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 15.0,
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
                          isReadOnly: widget
                              .readOnly, // Disable segmented tabs if readOnly is true
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
  final bool isReadOnly;

  const SegmentedTab({
    Key? key,
    required this.segments,
    this.selectedSegment,
    this.onSegmentSelected,
    this.isReadOnly = false,
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
        onPressed: widget.isReadOnly
            ? null // Disable interaction when isReadOnly is true
            : (index) {
                setState(() {
                  _selectedSegment = widget.segments[index];
                });
                if (widget.onSegmentSelected != null) {
                  widget.onSegmentSelected!(_selectedSegment);
                }
              },
        borderRadius: BorderRadius.circular(15.0),
        fillColor: 
             AppColors.primary ,// Conditional fill color
        selectedColor: widget.isReadOnly
            ? Colors.white
            : AppColors.primary, // Conditional text color
        color: widget.isReadOnly
            ? Colors.white.withOpacity(0.7) // Disabled state color
            : Colors.black, // Enabled state color
        constraints: BoxConstraints(minHeight: 30, minWidth: 50),
        children: widget.segments
            .map((segment) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7.0, vertical: 5.0),
                  child: Text(
                    segment,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: segment == _selectedSegment
                          ? (widget.isReadOnly ? Colors.red : Colors.white)
                          : (widget.isReadOnly ? Colors.grey : Colors.grey),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

