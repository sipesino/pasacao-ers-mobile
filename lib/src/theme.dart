import 'package:pers/src/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Let's apply light and dark theme on our app

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Color(0xFFF4F4FA),
    appBarTheme: appBarTheme,
    bottomAppBarColor: Color(0xFFF4F4FA),
    iconTheme: const IconThemeData(color: primaryColor),
    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: primaryColor),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColor,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColor,
        ),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColor,
        ),
      ),
      labelStyle: TextStyle(
        color: primaryColor,
      ),
    ),
    // colorScheme: ColorScheme.light(
    //   primary: primaryColor,
    //   secondary: secondaryColor,
    // ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: accentColor,
      selectedLabelStyle: TextStyle(color: accentColor),
      unselectedItemColor: primaryColor.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: chromeColor),
    ),
  );
}

// ThemeData darkThemeData(BuildContext context) {
// By default flutter provide us light and dark theme
// we just modify it as our need
//   return ThemeData.dark().copyWith(
//     primaryColor: primaryColor,
//     scaffoldBackgroundColor: contentColorLightTheme,
//     appBarTheme: appBarTheme,
//     iconTheme: const IconThemeData(color: contentColorDarkTheme),
//     textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
//         .apply(bodyColor: contentColorDarkTheme),
//     colorScheme: const ColorScheme.dark().copyWith(
//       primary: primaryColor,
//       secondary: chromeColor,
//     ),
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//       backgroundColor: contentColorLightTheme,
//       selectedItemColor: Colors.white70,
//       unselectedItemColor: contentColorDarkTheme.withOpacity(0.32),
//       selectedIconTheme: const IconThemeData(color: chromeColor),
//       showUnselectedLabels: true,
//     ),
//   );
// }

const TextTheme DefaultTextTheme = TextTheme(
  headline1: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 30,
  ),
  headline2: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 22,
  ),
  headline3: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20,
  ),
  headline4: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
  ),
  headline5: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14,
  ),
  headline6: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 12,
  ),
  bodyText1: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.5,
  ),
  bodyText2: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.5,
  ),
  subtitle1: TextStyle(
    fontSize: 14,
    color: contentColorLightTheme,
  ),
  subtitle2: TextStyle(
    fontStyle: FontStyle.normal,
    fontSize: 14,
    color: Colors.grey,
  ),
);

const appBarTheme = AppBarTheme(
  centerTitle: false,
  elevation: 0,
  color: Color(0xFFF4F4FA),
  iconTheme: IconThemeData(color: primaryColor),
);
