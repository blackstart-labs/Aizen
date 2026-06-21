import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AizenTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF000000),
      canvasColor: const Color(0xFF000000),
      cardColor: const Color(0xFF121212),
      dialogBackgroundColor: const Color(0xFF121212),

      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF7C4DFF),
        onPrimary: Colors.black,
        primaryContainer: Color(0xFF1A1A1A),
        onPrimaryContainer: Colors.white,
        secondary: Color(0xFF00E676),
        onSecondary: Colors.black,
        secondaryContainer: Color(0xFF1A1A1A),
        surface: const Color(0xFF121212),
        onSurface: Colors.white,
        error: Color(0xFFFF5252),
        onError: Colors.black,
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
          TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
        },
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF121212),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF242426), width: 1.0),
        ),
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF121212),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF242426), width: 1.0),
        ),
        elevation: 0,
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF121212),
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: Color(0xFF121212),
        modalBarrierColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
      ),

      textTheme: GoogleFonts.lexendTextTheme(base.textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),

      splashFactory: InkSparkle.splashFactory,
      hoverColor: Colors.white10,
      splashColor: Colors.white.withValues(alpha: 0.15),
      highlightColor: Colors.transparent,
    );
  }
}

class AizenScrollBehavior extends MaterialScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
