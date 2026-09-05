class Templates {
  // =========================================================================
  // 🎨 CORE THEME & WIDGET THEMES
  // =========================================================================

  static const String textThemeContent = '''
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';

class UTextTheme {
  // private constructor
  UTextTheme._();

  // --- LIGHT TEXT THEME ---
  static TextTheme lightTextTheme(BuildContext context) => TextTheme(
    headlineLarge: TextStyle(fontSize: 32.spMin, fontWeight: FontWeight.bold, color: UColors.textDark),
    headlineMedium: TextStyle(fontSize: 24.spMin, fontWeight: FontWeight.w600, color: UColors.textDark),
    headlineSmall: TextStyle(fontSize: 18.spMin, fontWeight: FontWeight.w600, color: UColors.textDark),

    titleLarge: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.w600, color: UColors.textDark),
    titleMedium: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.w500, color: UColors.textDark),
    titleSmall: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.w400, color: UColors.textDark),

    bodyLarge: TextStyle(fontSize: 14.spMin, fontWeight: FontWeight.w500, color: UColors.textDark),
    bodyMedium: TextStyle(fontSize: 14.spMin, fontWeight: FontWeight.normal, color: UColors.textDark),
    bodySmall: TextStyle(fontSize: 14.spMin, fontWeight: FontWeight.w500, color: UColors.textDark.withValues(alpha: 0.7)),

    labelLarge: TextStyle(fontSize: 12.spMin, fontWeight: FontWeight.normal, color: UColors.textDark),
    labelMedium: TextStyle(fontSize: 12.spMin, fontWeight: FontWeight.normal, color: UColors.textDark.withValues(alpha: 0.5)),
  );

  // --- DARK TEXT THEME ---
  static TextTheme darkTextTheme(BuildContext context) => TextTheme(
    headlineLarge: TextStyle(fontSize: 32.spMin, fontWeight: FontWeight.bold, color: UColors.textWhite),
    headlineMedium: TextStyle(fontSize: 24.spMin, fontWeight: FontWeight.w600, color: UColors.textWhite),
    headlineSmall: TextStyle(fontSize: 18.spMin, fontWeight: FontWeight.w600, color: UColors.textWhite),

    titleLarge: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.w600, color: UColors.textWhite),
    titleMedium: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.w500, color: UColors.textWhite),
    titleSmall: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.w400, color: UColors.textWhite),

    bodyLarge: TextStyle(fontSize: 14.spMin, fontWeight: FontWeight.w500, color: UColors.textWhite),
    bodyMedium: TextStyle(fontSize: 14.spMin, fontWeight: FontWeight.normal, color: UColors.textWhite),
    bodySmall: TextStyle(fontSize: 14.spMin, fontWeight: FontWeight.w500, color: UColors.textWhite.withValues(alpha: 0.5)),

    labelLarge: TextStyle(fontSize: 12.spMin, fontWeight: FontWeight.normal, color: UColors.textWhite),
    labelMedium: TextStyle(fontSize: 12.spMin, fontWeight: FontWeight.normal, color: UColors.textWhite.withValues(alpha: 0.5)),
  );
}
''';

  static const String appBarThemeContent = '''
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';


class UAppBarTheme{
  UAppBarTheme._();

  static final lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: UColors.black, size: USizes.iconMd),
    actionsIconTheme: IconThemeData(color: UColors.black, size: USizes.iconMd),
    titleTextStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: UColors.black),
  );
  static final darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: UColors.white, size: USizes.iconMd),
    actionsIconTheme: IconThemeData(color: UColors.white, size: USizes.iconMd),
    titleTextStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: UColors.white),
  );
}
''';

  static const String bottomSheetThemeContent = '''
import 'package:flutter/material.dart';
import '../../constants/colors.dart';


class UBottomSheetTheme {
  UBottomSheetTheme._();

  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: UColors.white,
    modalBackgroundColor: UColors.white,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: UColors.black,
    modalBackgroundColor: UColors.black,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}
''';

  static const String checkboxThemeContent = '''
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';


class UCheckboxTheme {
  UCheckboxTheme._();


  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(USizes.xs)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return UColors.white;
      } else {
        return UColors.black;
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return UColors.primary;
      } else {
        return Colors.transparent;
      }
    }),
  );


  static CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(USizes.xs)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return UColors.white;
      } else {
        return UColors.black;
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return UColors.primary;
      } else {
        return Colors.transparent;
      }
    }),
  );
}
''';

  static const String chipThemeContent = '''
import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class UChipTheme{

  // private constructor
  UChipTheme._();


  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: UColors.grey.withValues(alpha: 0.4),
    labelStyle: const TextStyle(color: UColors.black),
    selectedColor: UColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: UColors.white,
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    disabledColor: UColors.darkerGrey,
    labelStyle: TextStyle(color: UColors.white),
    selectedColor: UColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: UColors.white,
  );
}
''';

  static const String elevatedButtonThemeContent = '''
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class UElevatedButtonTheme {
  UElevatedButtonTheme._();

  //  Light Theme Button
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: UColors.light,
      backgroundColor: UColors.primary,
      disabledForegroundColor: UColors.darkGrey,
      disabledBackgroundColor: UColors.buttonDisabled,
      side: const BorderSide(color: UColors.light),
      padding: EdgeInsets.symmetric(vertical: USizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: UColors.textWhite, fontWeight: FontWeight.w700),
    ),
  );


  //  Dark Theme Button
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: UColors.light,
      backgroundColor: UColors.primary,
      disabledForegroundColor: UColors.darkGrey,
      disabledBackgroundColor: UColors.darkerGrey,
      side: const BorderSide(color: UColors.primary),
      padding: EdgeInsets.symmetric(vertical: USizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: UColors.textWhite, fontWeight: FontWeight.w600),
    ),
  );


  // Theme-Aware Custom Modifications (Overriding Radius Dynamically)

  /// Returns the current global theme style with an overridden border radius of 12
  static ButtonStyle radius12(BuildContext context) {
    return Theme.of(context).elevatedButtonTheme.style!.copyWith(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),        // Use: UElevatedButtonTheme.radius12(context)
      ),
    );
  }

  /// Returns the current global theme style with an overridden border radius of 48
  static ButtonStyle radius48(BuildContext context) {
    return Theme.of(context).elevatedButtonTheme.style!.copyWith(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),        // Use : UElevatedButtonTheme.radius48(context)
      ),
    );
  }
}
''';

  static const String outlinedButtonThemeContent = '''
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';




class UOutlinedButtonTheme {
  UOutlinedButtonTheme._();


  static final lightOutlinedButtonTheme  = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: UColors.dark,
      side: const BorderSide(color: UColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: UColors.black, fontWeight: FontWeight.w600),
      padding: EdgeInsets.symmetric(vertical: USizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(USizes.buttonRadius)),
    ),
  );


  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: UColors.light,
      side: const BorderSide(color: UColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: UColors.textWhite, fontWeight: FontWeight.w600),
      padding: EdgeInsets.symmetric(vertical: USizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(USizes.buttonRadius)),
    ),
  );


  // Theme-Aware Custom Modifications (Overriding Radius Dynamically)

  /// Returns the current global theme style with an overridden border radius of 12
  static ButtonStyle radius12(BuildContext context) {
    return Theme.of(context).outlinedButtonTheme.style!.copyWith(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),        // Use: UOutlinedButtonTheme.radius12(context)
      ),
    );
  }

  /// Returns the current global theme style with an overridden border radius of 48
  static ButtonStyle radius48(BuildContext context) {
    return Theme.of(context).outlinedButtonTheme.style!.copyWith(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),        // Use : UOutlinedButtonTheme.radius48(context)
      ),
    );
  }
}
''';

  static const String textFieldThemeContent = '''
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class UTextFormFieldTheme {
  UTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: UColors.black,
    suffixIconColor: UColors.black,
    fillColor: UColors.white,
    filled: true,
    labelStyle: TextStyle().copyWith(fontSize: USizes.fontSizeMd, color: UColors.textDark),
    hintStyle: TextStyle().copyWith(fontSize: USizes.fontSizeSm, color: UColors.darkGrey),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: UColors.black.withValues(alpha: 0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(USizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: UColors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(USizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: UColors.grey),
    ),
    focusedBorder:const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(USizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: UColors.dark),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(USizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: UColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(USizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: UColors.warning),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: UColors.white,
    suffixIconColor: UColors.white,
    labelStyle: TextStyle().copyWith(fontSize: USizes.fontSizeMd, color: UColors.textWhite),
    hintStyle: TextStyle().copyWith(fontSize: USizes.fontSizeSm, color: UColors.darkGrey),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: UColors.white.withValues(alpha: 0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(USizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: UColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(USizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: UColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(USizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: UColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(USizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: UColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(USizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: UColors.warning),
    ),
  );
}
''';

  static const String colorsContent = '''
import 'package:flutter/material.dart';

class UColors{

  UColors._();


  // Primary Color
  static const Color primary = Color(0xFF0A66D2);

  // Text colors
  static const Color textDark  = Color(0xFF1F2937);
  static const Color textWhite = Color(0xFFC9D1D9);


  // Background colors
  static const Color light = Color(0xFFF8F9FA);
  static const Color dark  = Color(0xFF0F1117);

  // Button colors
  static const Color buttonPrimary  = Color(0xFF009688);
  static const Color buttonDisabled = Color(0xFFFAFAFA);

  // Border colors
  static const Color borderPrimary   = Color(0xFFE5E6E6);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Error and validation colors
  static const Color error   = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info    = Color(0xFF1976D2);

  static const Color yellow  = Color(0xFFFFE24B);

  // Neutral Shades
  static const Color black      = Color(0xFF000000);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey   = Color(0xFF939393);
  static const Color grey       = Color(0xFFE0E0E0);
  static const Color lightGrey  = Color(0xFFF9F9F9);
  static const Color white      = Color(0xFFFFFFFF);

  // ── Progress card ──
  static const progCardLight        = Color(0xFFD6D3F7);
  static const progCardLightBorder  = Color(0xFFF0EFFF);
  static const progCardDark         = Color(0xFF1E2235);
  static const progCardDarkBorder   = Color(0xFF1E2235);

  // topic card
  static const cardDark       = Color(0xFF3E3E40);
  static const cardLight       = Color(0xFFF1F3F5);
  static const borderDark     = Color(0xFF2A2D42);
  static const borderLight     = Color(0xFFDCDCDC);

  // ── Bottom nav ──
  static const navBgLight       = Color(0xFFFFFFFF);
  static const navBgDark        = Color(0xFF0F1117);
  static const navBorderLight   = Color(0xFFE8EAF5);
  static const navBorderDark    = Color(0xFF1E2235);
  static const navActiveLight   = Color(0xFF4A5CDB);
  static const navActiveDark    = Color(0xFF8899FF);
  static const navInactiveLight = Color(0xFFAAAAAA);
  static const navInactiveDark  = Color(0xFF555555);
}
''';

  static const String sizesContent = ''' 
  
class USizes{
// Padding and margin sizes
  static const double xs = 4.0; // extra small
  static const double sm = 8.0; // small
  static const double md = 16.0; // medium
  static const double lg = 24.0; //large
  static const double xl = 32.0; //extra large

  // Icon sizes
  static const double iconXs = 12.0; // extra small
  static const double iconSm = 16.0; // small
  static const double iconMd = 24.0; // medium
  static const double iconLg = 32.0; // large

  // Font sizes
  static const double fontSizeSm = 14.0; // small
  static const double fontSizeMd = 16.0; // medium
  static const double fontSizeLg = 18.0; // large

  // Button sizes
  static const double buttonHeight = 18.0;
  static const double buttonRadius = 12.0;
  static const double buttonWidth = 120.0;
  static const double searchBarHeight = 50.0;

  // AppBar height
  static const double appBarHeight = 56.0;

  // Default spacing between sections
  static const double defaultSpace = 24.0;
  static const double spaceBtwItems = 16.0;
  static const double spaceBtwSections = 32.0;

  // Border radius
  static const double borderRadiusSm = 4.0;
  static const double borderRadiusMd = 8.0;
  static const double borderRadiusLg = 12.0;

  // Product item dimensions
  static const double productImageRadius = 16.0;

  // Input field
  static const double inputFieldRadius = 12.0;
  static const double spaceBtwInputFields = 16.0;

  // Card sizes
  static const double cardRadiusLg = 16.0;
  static const double cardRadiusMd = 12.0;
  static const double cardRadiusSm = 10.0;
  static const double cardRadiusXs = 6.0;

  // Grid view spacing
  static const double gridViewSpacing = 16.0;

  // Card Sizes
  static const double homePrimaryHeaderHeight = 320.0; // 320
  static const double storePrimaryHeaderHeight = 170.0; // 170
  static const double profilePrimaryHeaderHeight = 170.0; // 170

  static const double brandCardWidth = 170.0; // 170
  static const double brandCardHeight = 70.0; // 70
}
''';

  static const String textsContent = ''' 
  class UTexts {
  // private Constructor
  UTexts._();

  static const String learnFlutter = "Learn Flutter";
  static const String email = "Email";
  static const String password = "Password";
  static const String login = "Login";
  static const String dontHave = "Don't have any account?";
  static const String signUp = "Sign Up";
  static const String forgetPassword = "Forget password?";
}
  ''';

  static const String appThemeContent = '''
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import 'text_theme.dart';
import 'widgets_theme/appbar_theme.dart';
import 'widgets_theme/botton_sheet_theme.dart';
import 'widgets_theme/checkbox_theme.dart';
import 'widgets_theme/chip_theme.dart';
import 'widgets_theme/elevated_button_theme.dart';
import 'widgets_theme/outlined_button_theme.dart';
import 'widgets_theme/text_field_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme(BuildContext context) => ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    brightness: Brightness.light,
    primaryColor: UColors.primary,
    disabledColor: UColors.grey,
    textTheme: UTextTheme.lightTextTheme(context),
    chipTheme: UChipTheme.lightChipTheme,
    scaffoldBackgroundColor: UColors.light,
    appBarTheme: UAppBarTheme.lightAppBarTheme,
    checkboxTheme: UCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: UBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: UElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: UOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: UTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    brightness: Brightness.dark,
    primaryColor: UColors.primary,
    disabledColor: UColors.grey,
    textTheme: UTextTheme.darkTextTheme(context),
    chipTheme: UChipTheme.darkChipTheme,
    scaffoldBackgroundColor: UColors.dark,
    appBarTheme: UAppBarTheme.darkAppBarTheme,
    checkboxTheme: UCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: UBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: UElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: UOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: UTextFormFieldTheme.darkInputDecorationTheme,
  );

  static ThemeMode get systemThemeMode => ThemeMode.system;
}
''';

  // =========================================================================
  // 🧭 ROUTER & HELPERS & EXTENSIONS
  // =========================================================================

  static const String appRouterContent = r'''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// App router configuration
/// Provides centralized routing with GoRouter
class AppRouter {
  AppRouter._(); // Private constructor to prevent instantiation

  /// Create and configure the router
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      // Add your routes here
      // Example:
      // GoRoute(
      //   path: '/login',
      //   name: 'login',
      //   builder: (context, state) => const LoginPage(),
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );

  /// Navigate to a route by path
  static void go(String path) {
    _router.go(path);
  }

  /// Navigate to a route by name
  static void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    _router.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Push a route
  static Future<T?> push<T extends Object?>(
    String path, {
    Object? extra,
  }) {
    return _router.push<T>(path, extra: extra);
  }

  /// Push a named route
  static Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    return _router.pushNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Pop the current route
  static void pop<T extends Object?>([T? result]) {
    _router.pop<T>(result);
  }

  /// Check if can pop
  static bool canPop() {
    return _router.canPop();
  }
}

/// Placeholder HomePage - replace with your actual home page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}
''';

  static const String deviceHelpersContent = '''
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// HELPER CLASS PART (Global functions - No context required)

class UDeviceHelper {
  UDeviceHelper._(); // Private constructor to prevent object instantiation

  // Change the top status bar background color
  static Future<void> setStatusBarColor(Color color) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color),                                     // Use: UDeviceHelper.setStatusBarColor(Colors.blue);
    );
  }

  // Toggle immersive fullscreen mode (Hide/Show status bar and navigation bar)
  static void setFullScreen(bool enable) {
    SystemChrome.setEnabledSystemUIMode(
      enable ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,                 // Use: UDeviceHelper.setFullScreen(true);
    );
  }

  // Get standard Flutter bottom navigation bar height (56.0 dp)
  static double getBottomNavigationBarHeight() {
    return kBottomNavigationBarHeight;                                                 // Use: double barHeight = UDeviceHelper.getBottomNavigationBarHeight();
  }

  // Get standard Flutter app bar / toolbar height (56.0 dp)
  static double getAppBarHeight() {
    return kToolbarHeight;                                                             // Use: double appBarH = UDeviceHelper.getAppBarHeight();
  }
}
''';


  static const String contextExtensionContent = '''
import 'package:flutter/material.dart';


// EXTENSION PART (BuildContext shortcuts - No parameter needed)

extension UDeviceExtension on BuildContext {

  // ── Theme Shortcuts ──

  // Get text theme styles
  TextTheme get tt => Theme.of(this).textTheme;                                        // Use: TextStyle style = context.tt.bodyLarge;

  // Get color scheme colors
  ColorScheme get cs => Theme.of(this).colorScheme;                                    // Use: Color primaryColor = context.cs.primary;

  // Check if the current theme is dark mode
  bool get isDark => Theme.of(this).brightness == Brightness.dark;                     // Use: if (context.isDark) { ... }


  // ── MediaQuery Shortcuts ──

  // Get full MediaQueryData object
  MediaQueryData get mq => MediaQuery.of(this);                                        // Use: Size size = context.mq.size;

  // Get full screen height
  double get screenHeight => MediaQuery.of(this).size.height;                          // Use: double height = context.screenHeight;

  // Get full screen width
  double get screenWidth => MediaQuery.of(this).size.width;                            // Use: double width = context.screenWidth;

  // Get current keyboard height on screen
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;                  // Use: double kbHeight = context.keyboardHeight;


  // ── Responsive Breakpoints Shortcuts ──

  // Check if the device is a mobile phone (width less than 600)
  bool get isPhone => screenWidth < 600;                                               // Use: if (context.isPhone) { ... }

  // Check if the device is a tablet (width between 600 and 899)
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;                        // Use: if (context.isTablet) { ... }

  // Check if the device is a desktop screen (width 900 or more)
  bool get isDesktop => screenWidth >= 900;                                            // Use: if (context.isDesktop) { ... }


  // ── Orientation Shortcuts ──

  // Check if screen is in portrait mode
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;      // Use: if (context.isPortrait) { ... }

  // Check if screen is in landscape mode
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;    // Use: if (context.isLandscape) { ... }


  // ── Actions Shortcuts ──

  // Hide software keyboard from screen
  void hideKeyboard() {
    FocusScope.of(this).requestFocus(FocusNode());                                     // Use: context.hideKeyboard();
  }
}
''';

  // =========================================================================
  // ⚡ BACKEND (DIO / HIVE / DEPENDENCY INJECTION)
  // =========================================================================

  static const String dioClientContent = r'''
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Professional Dio client setup
/// Configured with interceptors, timeouts, and error handling
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add logging interceptor (only in debug mode)
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    // Add error interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Handle errors here
          return handler.next(error);
        },
      ),
    );
  }

  /// Get Dio instance
  Dio get dio => _dio;

  /// Set base URL
  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// Set authentication token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear authentication token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      rethrow;
    }
  }
}

''';

  static const String networkInfoContent = '''
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo(this._connectivity);

  /// Check if device is connected to internet
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(
      (result) => result != ConnectivityResult.none,
    );
  }
}
  ''';

  static const String hiveStorageContent = '''
import 'package:hive_flutter/hive_flutter.dart';

/// Centralized Local Storage Service using Hive
class StorageService {
  static Box? _box;

  /// Initialize Hive and open default storage box
  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('app_storage');
  }

  /// Get value by key with Type Safety
  static T? get<T>(String key, {T? defaultValue}) {
    return _box?.get(key, defaultValue: defaultValue) as T?;
  }

  /// Set key-value pair
  static Future<void> set(String key, dynamic value) async {
    await _box?.put(key, value);
  }

  /// Delete value by key
  static Future<void> delete(String key) async {
    await _box?.delete(key);
  }

  /// Clear all stored data
  static Future<void> clear() async {
    await _box?.clear();
  }

  /// Check if key exists
  static bool containsKey(String key) {
    return _box?.containsKey(key) ?? false;
  }

  /// Get all keys as a list
  static List<String> getAllKeys() {
    return _box?.keys.cast<String>().toList() ?? [];
  }

  /// Close box instance
  static Future<void> close() async {
    await _box?.close();
  }
}
''';

  // ========================================================
  //                      Utils
  // ========================================================
  static const String apiEndpointContent = r'''
  /// API endpoints configuration
/// Centralized location for all API endpoints
class ApiEndpoint {
  // Private constructor to prevent instantiation
  ApiEndpoint._();

  // Base URL
  // TODO: Replace with your actual base URL
  static const String baseUrl = 'https://api.example.com';

  // API Version
  static const String apiVersion = '/v1';

  // Full base URL with version
  static String get baseUrlWithVersion => '$baseUrl$apiVersion';

  // TODO: Add your API endpoints here
  // Example:
  // static const String login = '/auth/login';
  // static const String register = '/auth/register';
  // static const String logout = '/auth/logout';
  // static const String profile = '/user/profile';
  // static const String updateProfile = '/user/profile/update';

  // Auth endpoints
  // static const String login = '$apiVersion/auth/login';
  // static const String register = '$apiVersion/auth/register';
  // static const String refreshToken = '$apiVersion/auth/refresh';
  // static const String logout = '$apiVersion/auth/logout';

  // User endpoints
  // static const String getUserProfile = '$apiVersion/user/profile';
  // static const String updateUserProfile = '$apiVersion/user/profile';
  // static const String deleteUser = '$apiVersion/user/delete';

  // Helper method to build full URL
  static String buildUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
}
  ''';

  static const String appLoggerContent = r'''
  import 'package:flutter/foundation.dart';

/// Application logger utility
/// Provides consistent logging throughout the app
class AppLogger {
  // Private constructor to prevent instantiation
  AppLogger._();

  /// Log debug message
  static void debug(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('$prefix$message');
    }
  }

  /// Log info message
  static void info(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('ℹ️  $prefix$message');
    }
  }

  /// Log warning message
  static void warning(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('⚠️  $prefix$message');
    }
  }

  /// Log error message
  static void error(String message, [Object? error, StackTrace? stackTrace, String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('❌ $prefix$message');
      if (error != null) {
        debugPrint('Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }
  }

  /// Log success message
  static void success(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('✅ $prefix$message');
    }
  }

  /// Log network request
  static void network(String method, String url, {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      debugPrint('🌐 $method $url');
      if (data != null) {
        debugPrint('Data: $data');
      }
    }
  }

  /// Log network response
  static void networkResponse(int statusCode, String url, {dynamic data}) {
    if (kDebugMode) {
      debugPrint('📡 Response $statusCode: $url');
      if (data != null) {
        debugPrint('Data: $data');
      }
    }
  }
}
  ''';

  static const String dependencyInjectionContent = '''
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'core/network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  _setUpCore();
}

Future<void> initDependencies() async => init();

// Core: Shared resources for all features
void _setUpCore() {
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);
}
''';

  // =========================================================================
  // 🚀 MAIN.DART & APP.DART
  // =========================================================================

  static const String appDartContent = '''
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          // Remove debug banner
          debugShowCheckedModeBanner: false,
          // App title (shows in task switcher)
          title: 'App',

          theme: AppTheme.lightTheme(context),

          darkTheme: AppTheme.darkTheme(context),
          // Use system theme mode (light/dark based on device settings)
          themeMode: ThemeMode.system,
        );
      },
    );
  }
}
''';

  static const String mainDartContent = '''
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/hive_service.dart';
import 'injection.dart';

export 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await StorageService.init();

  // Initialize Dependency Injection
  await init();

  runApp(const MyApp());
}
''';

  // =========================================================================
  // 📦 FEATURE SCAFFOLDING TEMPLATES
  // =========================================================================

  static String getDataSourceContent(String pascalName) => '''
import 'package:dio/dio.dart';

abstract class ${pascalName}DataSource {
}

class ${pascalName}DataSourceImplement implements ${pascalName}DataSource {
  final Dio dio;

  ${pascalName}DataSourceImplement({required this.dio});
}
''';

  static String getEntityContent(String pascalName) => '''
class ${pascalName}Entity {
  const ${pascalName}Entity();
}
''';

  static String getModelContent(String pascalName) => '''
class ${pascalName}Model {
  const ${pascalName}Model();

  factory ${pascalName}Model.fromJson(Map<String, dynamic> json) {
    return const ${pascalName}Model();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
''';

  static String getRepoImplContent(String pascalName, String snakeName) => '''
import '../../domain/repositories/${snakeName}_repository.dart';
import '../data_sources/${snakeName}_data_source.dart';

class ${pascalName}RepositoryImplement implements ${pascalName}Repository {
  final ${pascalName}DataSource dataSource;

  ${pascalName}RepositoryImplement({required this.dataSource});
}
''';

  static String getRepoContent(String pascalName) => '''
abstract class ${pascalName}Repository {
}
''';

  static String getUseCaseContent(String pascalName, String snakeName) => '''
import '../repositories/${snakeName}_repository.dart';

class ${pascalName}UseCase {
  final ${pascalName}Repository repository;

  ${pascalName}UseCase({required this.repository});
}
''';

  static String getControllerContent(String pascalName, String snakeName) => '''
import '../../../domain/usecases/${snakeName}_usecase.dart';

class ${pascalName}Controller {
  final ${pascalName}UseCase useCase;

  ${pascalName}Controller(this.useCase);
}
''';

  static String getScreenContent(String pascalName) => '''
import 'package:flutter/material.dart';

class ${pascalName}Screen extends StatelessWidget {
  const ${pascalName}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$pascalName'),
      ),
      body: const Center(
        child: Text('$pascalName Screen'),
      ),
    );
  }
}
''';
}