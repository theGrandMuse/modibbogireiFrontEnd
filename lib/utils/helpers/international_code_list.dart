import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';

class InternationalCodeList extends StatelessWidget {
  const InternationalCodeList({super.key});

  @override
  Widget build(BuildContext context) {
   // final controller = Get.put(CurrenciesController());
    return CSCPicker(
      showStates: false,
      showCities: false,
      layout: Layout.vertical,
      flagState: CountryFlag.ENABLE,

      ///triggers once country selected in dropdown
      onCountryChanged: (value) {
        ///store value in country variable
       // controller.countryValue = value;
      },

      ///placeholders for dropdown search field
      countrySearchPlaceholder: "Country",

      ///labels for dropdown
      countryDropdownLabel: "Country",

      dropdownDialogRadius: 12.0,
      searchBarRadius: 12.0,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        // color: Color(0xFFB0D9B1),
        border: Border.all(color: TColors.backColor, width: 1.5),
      ),

      disabledDropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),

        // color: Color(0xFFD0E7D2),
        border: Border.all(color: TColors.backColor, width: 1.5),
      ),

      ///selected item style [OPTIONAL PARAMETER]
      selectedItemStyle: TextStyle(
        height: 3,
        fontWeight: FontWeight.bold,
        color: TColors.grayColor,
        fontSize: 14,
      ),

      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
      dropdownHeadingStyle: TextStyle(
          color: Colors.grey.shade900,
          fontSize: 17,
          fontWeight: FontWeight.bold),

      ///DropdownDialog Item style [OPTIONAL PARAMETER]
      dropdownItemStyle: TextStyle(
        color: Colors.grey.shade800,
        fontSize: 14,
      ),
    );
  }
}
