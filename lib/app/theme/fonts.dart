import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marocsie/app/theme/colors.dart';

// Updated font sizes
const double titleText = 24; // LinkedIn-like header size
const double subTitleText = 18; // LinkedIn-like subtitle size
const double normalText = 14; // LinkedIn-like normal text size
const double smallText = 12; // LinkedIn-like small text size

// Error text style
final TextStyle largeErrorTextStyle = GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: errorColor,
  fontSize: titleText,
  fontWeight: FontWeight.bold, // Bold for emphasis
);

// Light title style
TextStyle lightTitleStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: lightColor,
  fontSize: titleText,
  fontWeight: weight,
);

// Dark title style (LinkedIn's primary text color is dark)
TextStyle darkTitleStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: darkColor,
  fontSize: titleText,
  fontWeight: weight,
);

// Primary title style (LinkedIn's blue for emphasis)
TextStyle primaryTitleStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: primaryColor,
  fontSize: titleText,
  fontWeight: weight,
);

TextStyle primarySubTitleStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: primaryColor,
  fontSize: subTitleText,
  fontWeight: weight,
);

// Secondary title style
TextStyle secondaryTitleStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: secondaryColor,
  fontSize: titleText,
  fontWeight: weight,
);

// Subtitle style
TextStyle subTitleStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: lightColor,
  fontSize: subTitleText,
  fontWeight: weight,
);

// Dark subtitle style
TextStyle darkSubTitleStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: darkColor,
  fontSize: subTitleText,
  fontWeight: weight,
);

// Light normal text style
TextStyle lightNormalTextStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: lightColor,
  fontSize: normalText,
  fontWeight: weight,
);

// Dark normal text style (LinkedIn's primary text color)
TextStyle darkNormalTextStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: darkColor,
  fontSize: normalText,
  fontWeight: weight,
);

// Primary normal text style (LinkedIn's blue for links)
TextStyle primaryNormalTextStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: primaryColor,
  fontSize: normalText,
  fontWeight: weight,
);

TextStyle successNormalTextStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: primaryColor,
  fontSize: normalText,
  fontWeight: weight,
);

// Gray normal text style (LinkedIn's secondary text color)
TextStyle grayNormalTextStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: grayColor,
  fontSize: normalText,
  fontWeight: weight,
);

// Red normal text style (for errors)
TextStyle redNormalTextStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: errorColor,
  fontSize: normalText,
  fontWeight: weight,
);

// Small light text style
final TextStyle smallLightTextStyle = GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: lightColor,
  fontSize: smallText,
);

// Small dark text style
final TextStyle smallDarkTextStyle = GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: darkColor,
  fontSize: smallText,
);

// Light button text style
TextStyle lightButtonTextStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: whiteColor,
  fontSize: normalText,
  fontWeight: weight,
);

// Small light button text style
TextStyle smalllightButtonTextStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: lightColor,
  fontSize: smallText,
  fontWeight: weight,
);

// Dark button text style
TextStyle darkButtonTextStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: darkColor,
  fontSize: normalText,
  fontWeight: weight,
);

// Small dark button text style
TextStyle smallDarkButtonTextStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: darkColor,
  fontSize: smallText,
  fontWeight: weight,
);

// Primary button text style (LinkedIn's blue for buttons)
TextStyle primaryButtonTextStyle(FontWeight weight) => GoogleFonts.montserrat(
  fontStyle: FontStyle.normal,
  color: primaryColor,
  fontSize: 16, // Slightly larger for buttons
  fontWeight: FontWeight.w600, // Medium weight for buttons
);

// Primary text button style (underlined for links)
TextStyle primaryTextButtonTextStyle(FontWeight weight) => GoogleFonts.montserrat(
  decoration: TextDecoration.underline,
  fontStyle: FontStyle.normal,
  color: primaryColor,
  fontSize: normalText,
  fontWeight: weight,
);