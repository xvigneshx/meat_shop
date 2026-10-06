import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meat_shop/customers/home.dart';
import 'package:meat_shop/router.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'The Meat Shop',
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}

class AppColors {
  static const surface = Color(0xFFF8F9FF);
  static const surfaceDim = Color(0xFFD6DAE4);
  static const surfaceBright = Color(0xFFF8F9FF);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF0F4FD);
  static const surfaceContainer = Color(0xFFEAEef8);
  static const surfaceContainerHigh = Color(0xFFE4E8F2);
  static const surfaceContainerHighest = Color(0xFFDEE2EC);

  static const onSurface = Color(0xFF171C23);
  static const onSurfaceVariant = Color(0xFF584140);

  static const inverseSurface = Color(0xFF2C3138);
  static const inverseOnSurface = Color(0xFFEDF1FB);

  static const outline = Color(0xFF8B716F);
  static const outlineVariant = Color(0xFFDFBFBD);

  static const primary = Color(0xFF6B020E);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF8B1E22);
  static const onPrimaryContainer = Color(0xFFFF9D98);

  static const secondary = Color(0xFF745853);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFFED7D0);
  static const onSecondaryContainer = Color(0xFF795C57);

  static const tertiary = Color(0xFF4A2B05);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFF644119);
  static const onTertiaryContainer = Color(0xFFE0AE7D);

  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  // Brand/style colors from the design specification.
  static const butcherCrimson = Color(0xFF8B1E22);
  static const curedUmber = Color(0xFF3E2723);
  static const rawTwine = Color(0xFFD4A373);
  static const slateCharcoal = Color(0xFF1E232A);
  static const warmParchment = Color(0xFFF9F6F0);
  static const boneWhite = Color(0xFFFFFFFF);
  static const pressedLinen = Color(0xFFE6E0D6);
}

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,

    fontFamily: 'Plus Jakarta Sans',

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,

      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,

      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,

      surface: AppColors.warmParchment,
      onSurface: AppColors.slateCharcoal,

      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,

      outline: AppColors.pressedLinen,
      outlineVariant: AppColors.outlineVariant,
    ),

    scaffoldBackgroundColor: AppColors.warmParchment,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.warmParchment,
      foregroundColor: AppColors.slateCharcoal,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      color: AppColors.boneWhite,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        side: BorderSide(color: AppColors.pressedLinen, width: 1),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.boneWhite,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(color: AppColors.pressedLinen),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(color: AppColors.pressedLinen),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(
          color: AppColors.butcherCrimson,
          width: 1.5,
        ),
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.butcherCrimson,
        foregroundColor: AppColors.boneWhite,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.slateCharcoal,
        backgroundColor: AppColors.boneWhite,
        side: const BorderSide(color: AppColors.pressedLinen),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.boneWhite,
      selectedColor: AppColors.butcherCrimson,
      side: const BorderSide(color: AppColors.pressedLinen),
      shape: const StadiumBorder(),
      labelStyle: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 44 / 36,
        letterSpacing: -1.08,
        color: AppColors.slateCharcoal,
      ),

      displayMedium: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 38 / 30,
        letterSpacing: -0.75,
        color: AppColors.slateCharcoal,
      ),

      headlineLarge: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 34 / 26,
        letterSpacing: -0.52,
        color: AppColors.slateCharcoal,
      ),

      headlineMedium: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        letterSpacing: -0.3,
        color: AppColors.slateCharcoal,
      ),

      headlineSmall: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 24 / 17,
        letterSpacing: -0.17,
        color: AppColors.slateCharcoal,
      ),

      bodyLarge: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.slateCharcoal,
      ),

      bodyMedium: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 21 / 14,
        color: AppColors.slateCharcoal,
      ),

      bodySmall: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 17 / 12,
        color: AppColors.onSurfaceVariant,
      ),

      labelLarge: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 18 / 14,
        color: AppColors.slateCharcoal,
      ),

      labelMedium: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        color: AppColors.slateCharcoal,
      ),

      labelSmall: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 14 / 11,
        letterSpacing: 0.88,
        color: AppColors.slateCharcoal,
      ),
    ),
  );
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {
        // Firebase is checking the current authentication state.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _AuthLoadingScreen();
        }

        // Authentication check failed.
        if (snapshot.hasError) {
          return const _AuthErrorScreen();
        }

        // User is authenticated.
        if (snapshot.data != null) {
          return const WelcomeScreen();
        }

        // User is not authenticated.
        return const MeatShopScreen();
      },
    );
  }
}

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _AuthErrorScreen extends StatelessWidget {
  const _AuthErrorScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Unable to verify authentication')),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Welcome to The Meat Shop',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
