part of 'helpers.dart';

Color get kColorPrimaryDark => const Color(0xFF15191c);
Color get kColorPrimary => Colors.blue.shade700;
Color get kColorAccent => const Color(0xFFFFFFFF);

Color get kColorBackground => const Color(0xFF1d232a);

Color get kColorCardHint => const Color(0xFF353f47);
Color get kColorCard => const Color(0xFF2c343a);
Color get kColorMain => const Color(0xFFbd82ff);

Color get kColorChipHint => const Color(0xFF656f7c);

Color get kColorIconCardHint => const Color(0xFF4f5661);
Color get kColorIconHomeHint => const Color(0xFF5e656e);

Color get kColorError => const Color(0xff7b121d);
// Color get kColorBackground => const Color(0xFF1d232a);

List<Color> kListColors = [
  kColorPrimary,
  kColorPrimary.withOpacity(0.5),
  kColorCardHint,
];

List<BoxShadow> get kShadow => [
      const BoxShadow(
        color: Colors.black12,
        blurRadius: 3,
      ),
    ];
List<BoxShadow> get kShadowPrimary => [
      BoxShadow(
        color: kColorPrimary,
        blurRadius: 2,
        spreadRadius: 1.5,
      ),
    ];
