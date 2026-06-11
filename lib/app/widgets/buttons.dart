// ignore_for_file: must_be_immutable

import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';
import 'package:marocsie/app/utils/sizes.dart';
import 'package:flutter/material.dart';

class ElevatedButtonWithIcon extends StatelessWidget {
  const ElevatedButtonWithIcon({
    super.key,
    required this.onPressed,
    required this.buttonColor,
    required this.buttonText,
    required this.iconData,
    required this.textStyle,
    required this.iconColor,
  });
  final VoidCallback onPressed;
  final Color buttonColor;
  final String buttonText;
  final IconData iconData;
  final TextStyle textStyle;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(buttonColor),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)))),
      icon: Icon(iconData,color: iconColor,),
      onPressed: onPressed, label: Text(buttonText,style: textStyle,));
  }
}

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.buttonColor,
    required this.buttonText,
    required this.iconData,
    required this.textStyle,
    required this.iconColor,
  });
  final VoidCallback onPressed;
  final Color buttonColor;
  final String buttonText;
  final IconData iconData;
  final TextStyle textStyle;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(buttonColor),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)))),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                buttonText,
                style: textStyle,
              ),
              Icon(
                iconData,
                color: iconColor,
              )
            ],
          ),
        ));
  }
}

class OutlinedButtonWithIcon extends StatelessWidget {
  const OutlinedButtonWithIcon(
      {super.key,
      required this.onPressed,
      required this.buttonColor,
      required this.buttonText,
      required this.iconData,
      required this.textStyle,
      required this.iconColor,
      this.borderRadius = 5});

  final VoidCallback onPressed;
  final Color buttonColor;
  final String buttonText;
  final IconData iconData;
  final TextStyle textStyle;
  final Color iconColor;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius)))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                buttonText,
                style: textStyle,
              ),
              const Spacer(),
              Icon(
                iconData,
                color: iconColor,
              )
            ],
          ),
        ));
  }
}

class DefaultOutlinedButton extends StatelessWidget {
  const DefaultOutlinedButton({
    super.key,
    required this.onPressed,
    required this.buttonColor,
    required this.buttonText,
    required this.textStyle,
  });
  final VoidCallback onPressed;
  final Color buttonColor;
  final String buttonText;
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(buttonColor),
            
            shape: WidgetStateProperty.all(RoundedRectangleBorder(              
                borderRadius: BorderRadius.circular(15)))),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
          child: Center(
            child: Text(
              buttonText,
              style: textStyle,
            ),
          ),
        ));
  }
}



class MarocsieElevatedButton extends StatelessWidget {

   MarocsieElevatedButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    TextStyle? buttonTextStyle,
    this.buttonColor = primaryColor,
    this.width = 0.8,this.height = 0.05,
  }) : buttonTextStyle = buttonTextStyle ?? lightButtonTextStyle(FontWeight.bold);


  final VoidCallback onPressed;
  final String buttonText;
  Color buttonColor;
  double width;
  double height;
  TextStyle? buttonTextStyle;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * width,
      height: screenHeight * height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
        ),
        onPressed: onPressed, 
        child: Text(buttonText,style: buttonTextStyle,),
        )
        );
  }
}


 