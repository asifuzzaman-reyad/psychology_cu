import 'package:flutter/material.dart';

// light
ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: Colors.black, fontFamily: 'Lato', fontSize: 20),
        iconTheme: IconThemeData(color: Colors.black)),
    colorScheme: ColorScheme.light(
      primary: Colors.black,
    ),
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Lato'),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.amber.shade200),
  );
}

// dark
ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark()
      .copyWith(
      colorScheme: ColorScheme.dark(primary: Colors.white),
      textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Lato'),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.amber.shade200)
  );
}
