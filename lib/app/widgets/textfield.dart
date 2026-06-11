// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import 'package:marocsie/app/global/constants.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';
import 'package:marocsie/app/utils/sizes.dart';

InputBorder inputBorder = OutlineInputBorder(                    
  borderSide: BorderSide(color: primaryColor.withOpacity(0.2)),
  borderRadius: BorderRadius.circular(inputBorderRadius),
);

DropDownDecoratorProps dropDownDecoratorProps = DropDownDecoratorProps(
  baseStyle: const TextStyle(fontSize: 16),
  textAlign: TextAlign.start,
  decoration: InputDecoration(
    filled: true,
    fillColor: whiteColor,
    border: inputBorder,
    enabledBorder: inputBorder,
    focusedBorder: inputBorder,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    hintStyle: darkNormalTextStyle(FontWeight.bold)
  )
);

class MarocsiePhoneInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const MarocsiePhoneInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.0, left: screenWidth * 0.0, right: screenWidth * 0.0),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8, left: 10),
            child: Text(
              label,
              textAlign: TextAlign.start,
              style: darkNormalTextStyle(FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                // Country Code Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.call, size: 20, color: primaryColor),
                      const SizedBox(width: 4),
                      // Text(
                      //   "+251",
                      //   style: TextStyle(
                      //     color: primaryColor,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                // Phone Number Input
                Expanded(
                  child: TextField(
                    controller: controller,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    style: darkNormalTextStyle(FontWeight.normal),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: hintText,
                      hintStyle: grayNormalTextStyle(FontWeight.normal),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: onChanged,
                  ),
                ),
                // Clear Button
                if (controller.text.isNotEmpty)
                  IconButton(
                    icon: Icon(Iconsax.close_circle, size: 20, color: grayColor),
                    onPressed: () => controller.clear(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MarocsieNumberInPutField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final int maxLength;
  final int maxValue;
  
  const MarocsieNumberInPutField({
    super.key,
    required this.label,
    required this.controller, 
    required this.hintText, 
    this.maxLength = 2, 
    this.maxValue = 46,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0, left: screenWidth * 0.05, right: screenWidth * 0.05),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8, left: 10),
            child: Text(
              label,
              textAlign: TextAlign.start,
              style: darkNormalTextStyle(FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                // Number Input
                Expanded(
                  child: TextField(
                    controller: controller,
                    maxLength: maxLength,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: darkNormalTextStyle(FontWeight.normal),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: hintText,
                      hintStyle: grayNormalTextStyle(FontWeight.normal),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                // Clear Button
                if (controller.text.isNotEmpty)
                  IconButton(
                    icon: Icon(Iconsax.close_circle, size: 20, color: grayColor),
                    onPressed: () => controller.clear(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MarocsieTextInputWidget extends StatelessWidget {
  const MarocsieTextInputWidget({
    super.key,
    required this.label,
    required this.hintText,
    required this.onChanged,
    required this.controller,
    this.maxLine = 1,
    this.keyboardType = TextInputType.text
  });

  final String label;
  final String hintText;
  final Function onChanged;
  final int maxLine;
  final TextEditingController controller;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.0, left: screenWidth * 0.05, right: screenWidth * 0.05),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8, left: 10),
            child: Text(
              label,
              textAlign: TextAlign.start,
              style: darkNormalTextStyle(FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(0.2)),
            ),
            child: TextField(
              controller: controller,
              maxLines: maxLine,
              keyboardType: keyboardType,
              style: darkNormalTextStyle(FontWeight.normal),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: grayNormalTextStyle(FontWeight.normal),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              onChanged: (value) => onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
