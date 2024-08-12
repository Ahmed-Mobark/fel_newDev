part of 'helpers.dart';

// Light Mode

ThemeData darkThemeData(BuildContext context) {
  var baseTheme = Theme.of(context).textTheme;
  return ThemeData(

    primaryColor: kColorPrimary,
    primaryColorDark: kColorPrimaryDark,
    scaffoldBackgroundColor: kColorBackground,
    hintColor: kColorCardHint,
    cardColor: kColorCard,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
    fontFamily: "Algerian",
    appBarTheme: AppBarTheme(
      backgroundColor: kColorBackground,
      elevation: 0.0,
    ),
    iconTheme: IconThemeData(
      color: kColorCardHint,
    ),
    textTheme: GoogleFonts.alexandriaTextTheme(baseTheme).copyWith(
      displayLarge: GoogleFonts.poppins(
        color: kColorAccent,
        fontSize: 17.sp,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.poppins(
        color: kColorAccent,
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.poppins(
        color: kColorAccent,
        fontSize: 13.sp,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: kColorAccent,
        fontSize: 11.sp,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: kColorAccent,
        fontSize: 9.sp,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: kColorAccent,
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: GoogleFonts.openSans(
        color: kColorAccent,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.openSans(
        color: kColorAccent,
        fontSize: 11.sp,
      ),
      titleSmall: GoogleFonts.openSans(
        color: kColorAccent,
        fontSize: 9.sp,
      ),
      labelLarge: GoogleFonts.roboto(
        color: kColorAccent,
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
