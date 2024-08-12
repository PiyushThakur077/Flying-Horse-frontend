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
  final Function(String countryCode, String stateCode, String city)?
      onAddressSelected;

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
  }) : super(key: key);

  @override
  State<CommonTextInput> createState() => _CommonTextInputState();
}

class _CommonTextInputState extends State<CommonTextInput> {
  // Map of country names to their ISO2 codes
  final Map<String, String> countryIsoMap = {
    'Canada': 'CA',
    'United States': 'US',
    'Mexico': 'MX',
  };

  final Map<String, String> stateIsoMap = {
    // Canada
    'Alberta': 'AB',
    'British Columbia': 'BC',
    'Manitoba': 'MB',
    'New Brunswick': 'NB',
    'Newfoundland and Labrador': 'NL',
    'Northwest Territories': 'NT',
    'Nova Scotia': 'NS',
    'Nunavut': 'NU',
    'Ontario': 'ON',
    'Prince Edward Island': 'PE',
    'Quebec': 'QC',
    'Saskatchewan': 'SK',
    'Yukon': 'YT',
    // United States
    'Alabama': 'AL',
    'Alaska': 'AK',
    'Arizona': 'AZ',
    'Arkansas': 'AR',
    'California': 'CA',
    'Colorado': 'CO',
    'Connecticut': 'CT',
    'Delaware': 'DE',
    'Florida': 'FL',
    'Georgia': 'GA',
    'Hawaii': 'HI',
    'Idaho': 'ID',
    'Illinois': 'IL',
    'Indiana': 'IN',
    'Iowa': 'IA',
    'Kansas': 'KS',
    'Kentucky': 'KY',
    'Louisiana': 'LA',
    'Maine': 'ME',
    'Maryland': 'MD',
    'Massachusetts': 'MA',
    'Michigan': 'MI',
    'Minnesota': 'MN',
    'Mississippi': 'MS',
    'Missouri': 'MO',
    'Montana': 'MT',
    'Nebraska': 'NE',
    'Nevada': 'NV',
    'New Hampshire': 'NH',
    'New Jersey': 'NJ',
    'New Mexico': 'NM',
    'New York': 'NY',
    'North Carolina': 'NC',
    'North Dakota': 'ND',
    'Ohio': 'OH',
    'Oklahoma': 'OK',
    'Oregon': 'OR',
    'Pennsylvania': 'PA',
    'Rhode Island': 'RI',
    'South Carolina': 'SC',
    'South Dakota': 'SD',
    'Tennessee': 'TN',
    'Texas': 'TX',
    'Utah': 'UT',
    'Vermont': 'VT',
    'Virginia': 'VA',
    'Washington': 'WA',
    'West Virginia': 'WV',
    'Wisconsin': 'WI',
    'Wyoming': 'WY',
    // Mexico
    'Aguascalientes': 'AG',
    'Baja California': 'BC',
    'Baja California Sur': 'BS',
    'Campeche': 'CM',
    'Chiapas': 'CS',
    'Chihuahua': 'CH',
    'Coahuila': 'CO',
    'Colima': 'CL',
    'Durango': 'DG',
    'Guanajuato': 'GT',
    'Guerrero': 'GR',
    'Hidalgo': 'HG',
    'Jalisco': 'JA',
    'Mexico City': 'DF',
    'Mexico State': 'EM',
    'Michoacán': 'MI',
    'Morelos': 'MO',
    'Nayarit': 'NA',
    'Nuevo León': 'NL',
    'Oaxaca': 'OA',
    'Puebla': 'PU',
    'Querétaro': 'QT',
    'Quintana Roo': 'QR',
    'San Luis Potosí': 'SL',
    'Sinaloa': 'SI',
    'Sonora': 'SO',
    'Tabasco': 'TB',
    'Tamaulipas': 'TM',
    'Tlaxcala': 'TL',
    'Veracruz': 'VE',
    'Yucatán': 'YU',
    'Zacatecas': 'ZA',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            widget.labelText,
            style: AppTextStyle.mediumStyle(
                fontSize: 15, color: Color(0xff000000)),
          ),
        ),
        const SizedBox(height: 6),
        if (widget.isCountryPicker)
          CSCPicker(
            flagState: CountryFlag.DISABLE,
            onCountryChanged: (country) {
              widget.countryController?.text = country;
            },
            onStateChanged: (state) {
              widget.stateController?.text = state ?? '';
              String iso2StateCode = stateIsoMap[state] ?? '';
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
              if (widget.countryController?.text != null &&
                  widget.stateController?.text != null) {
                String countryCode = widget.countryController!.text;
                String stateCode =
                    stateIsoMap[widget.stateController!.text] ?? 'Unknown';
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
              border: Border.all(color: Colors.grey.shade300),
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
            height: 50,
            child: TextFormField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              readOnly: widget.readOnly,
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
