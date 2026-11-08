import 'package:flutter/material.dart';

class CyberColors {
  CyberColors._();

  static const Color bgVoid = Color(0xFF07080E);
  static const Color bgSurface = Color(0xFF0E101B);
  static const Color bgCard = Color(0xFF141829);
  static const Color bgInput = Color(0xFF0A0D18);

  static const Color neonRed = Color(0xFFFF1744);
  static const Color neonRedSoft = Color(0xFFFF5277);
  static const Color neonCyan = Color(0xFF00F0FF);
  static const Color neonPurple = Color(0xFFA855F7);

  static const Color neonGreen = Color(0xFF00FF9C);
  static const Color neonAmber = Color(0xFFFFB800);

  static const Color textPrimary = Color(0xFFF4F6FF);
  static const Color textSecondary = Color(0xFF949EC2);
  static const Color borderDim = Color(0xFF262D47);

  static String toHex(Color color) {
    final int argb = color.toARGB32();
    final String hex = (argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return '#${hex.toUpperCase()}';
  }
}

class CyberTheme {
  CyberTheme._();

  static ThemeData get darkTheme {
    final OutlineInputBorder baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: CyberColors.borderDim, width: 1.2),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Exo2',
      scaffoldBackgroundColor: CyberColors.bgVoid,
      colorScheme: const ColorScheme.dark(
        primary: CyberColors.neonRed,
        secondary: CyberColors.neonCyan,
        tertiary: CyberColors.neonPurple,
        surface: CyberColors.bgSurface,
        error: CyberColors.neonRedSoft,
        onPrimary: Colors.white,
        onSecondary: CyberColors.bgVoid,
        onSurface: CyberColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: CyberColors.bgSurface,
        foregroundColor: CyberColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Oxanium',
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: CyberColors.textPrimary,
          letterSpacing: 0.5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CyberColors.bgInput,
        labelStyle: const TextStyle(color: CyberColors.textSecondary),
        floatingLabelStyle: const TextStyle(
          color: CyberColors.neonCyan,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: CyberColors.textSecondary.withValues(alpha: 0.55),
          fontSize: 13.5,
        ),
        errorMaxLines: 2,
        errorStyle: const TextStyle(
          color: CyberColors.neonRedSoft,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: const BorderSide(color: CyberColors.neonCyan, width: 1.6),
        ),
        errorBorder: baseBorder.copyWith(
          borderSide: const BorderSide(color: CyberColors.neonRed, width: 1.4),
        ),
        focusedErrorBorder: baseBorder.copyWith(
          borderSide: const BorderSide(
            color: CyberColors.neonRedSoft,
            width: 1.8,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: CyberColors.bgSurface,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: CyberColors.neonRed, width: 1.2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: CyberColors.bgCard,
        contentTextStyle: const TextStyle(
          color: CyberColors.textPrimary,
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: CyberColors.neonRed, width: 1.2),
        ),
      ),
    );
  }
}

class CyberGridBackground extends StatelessWidget {
  const CyberGridBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _CyberGridPainter()),
          ),
        ),
        child,
      ],
    );
  }
}

class _CyberGridPainter extends CustomPainter {
  const _CyberGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint redGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          CyberColors.neonRed.withValues(alpha: 0.14),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(center: Offset(size.width * 0.1, 40), radius: 240),
      );
    canvas.drawRect(Offset.zero & size, redGlow);

    final Paint purpleGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          CyberColors.neonPurple.withValues(alpha: 0.11),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.92, size.height * 0.35),
          radius: 260,
        ),
      );
    canvas.drawRect(Offset.zero & size, purpleGlow);

    final Paint cyanGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          CyberColors.neonCyan.withValues(alpha: 0.09),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.2, size.height * 0.88),
          radius: 230,
        ),
      );
    canvas.drawRect(Offset.zero & size, cyanGlow);

    final Paint gridPaint = Paint()
      ..color = CyberColors.neonCyan.withValues(alpha: 0.035)
      ..strokeWidth = 1;

    const double step = 32;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CyberCard extends StatelessWidget {
  const CyberCard({
    super.key,
    required this.child,
    this.borderColor = CyberColors.neonRed,
    this.padding = const EdgeInsets.all(16),
    this.cutSize = 10,
    this.glowOpacity = 0.16,
  });

  final Widget child;
  final Color borderColor;
  final EdgeInsetsGeometry padding;
  final double cutSize;
  final double glowOpacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CyberColors.bgCard,
            CyberColors.bgSurface.withValues(alpha: 0.96),
          ],
        ),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(cutSize),
            bottomRight: Radius.circular(cutSize),
            topRight: const Radius.circular(4),
            bottomLeft: const Radius.circular(4),
          ),
          side: BorderSide(
            color: borderColor.withValues(alpha: 0.75),
            width: 1.2,
          ),
        ),
        shadows: [
          BoxShadow(
            color: borderColor.withValues(alpha: glowOpacity),
            blurRadius: 14,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class CyberSectionHeader extends StatelessWidget {
  const CyberSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.accentColor = CyberColors.neonRed,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Color accentColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 34,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.7),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Oxanium',
                  fontSize: 10.5,
                  letterSpacing: 1.6,
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Oxanium',
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: CyberColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
