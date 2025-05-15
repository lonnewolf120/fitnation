// login_screen.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// Remove direct color imports if they are now handled by the theme
import '../core/theme/colors.dart';
class LoginScreen extends StatefulWidget {
  // ...
}

class _LoginScreenState extends State<LoginScreen> {
  // ...
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context); // Get the current theme

    return Scaffold(
      // backgroundColor: theme.scaffoldBackgroundColor, // Already handled by MaterialApp
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.05),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.star_outline_sharp,
                  size: 50,
                  color: theme.colorScheme.onBackground, // Use theme color
                ),
                SizedBox(height: screenHeight * 0.03),

                RichText(
                  text: TextSpan(
                    // style: theme.textTheme.displayLarge, // Use theme text style
                    // Or define a specific style that uses theme colors
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onBackground, // Use theme color
                        height: 1.3),
                    children: <TextSpan>[
                      const TextSpan(text: 'Log in to your account'),
                      TextSpan(
                        text: '✨',
                        style: TextStyle(fontSize: 28, color: Colors.amber[300]), // Keep specific sparkle color
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Welcome back! Please enter your details.',
                  style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                SizedBox(height: screenHeight * 0.04),

                Text('Email', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.8))),
                SizedBox(height: screenHeight * 0.01),
                TextFormField(
                  style: TextStyle(color: theme.colorScheme.onSurface), // For input text color
                  decoration: InputDecoration( // Theme already styles this largely
                    hintText: 'Enter your email',
                    // hintStyle: theme.inputDecorationTheme.hintStyle, // Handled by theme
                    prefixIcon: Icon(Icons.email_outlined /*, color: theme.inputDecorationTheme.prefixIconColor*/), // Handled
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) { /* ... */ },
                ),
                SizedBox(height: screenHeight * 0.03),

                Text('Password', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.8))),
                SizedBox(height: screenHeight * 0.01),
                TextFormField(
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        // color: theme.inputDecorationTheme.suffixIconColor, // Handled by theme
                      ),
                      onPressed: () { /* ... */ },
                    ),
                  ),
                  validator: (value) { /* ... */ },
                ),
                SizedBox(height: screenHeight * 0.02),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24, height: 24,
                          child: Checkbox( // Theme handles checkbox styling
                            value: _rememberMe,
                            onChanged: (bool? value) { /* ... */ },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('Remember for 30 days', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7))),
                      ],
                    ),
                    TextButton(
                      onPressed: () { /* ... */ },
                      // style: theme.textButtonTheme.style, // Handled by theme
                      child: Text('Forgot password', style: TextStyle(color: theme.colorScheme.primary)), // Or use TextButtonTheme
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),

                _buildGradientButton( // This widget needs to be theme-aware or accept theme colors
                  text: 'Log In',
                  onPressed: () { /* ... */ },
                  width: double.infinity,
                  height: 50,
                  contextForTheme: context, // Pass context or theme
                ),
                SizedBox(height: screenHeight * 0.03),

                _buildSocialButton(
                  icon: Icons.g_mobiledata_sharp,
                  text: 'Log in with Google',
                  onPressed: () {},
                  iconColor: AppColors.googleRed, // Keep specific brand color
                  contextForTheme: context,
                  width: double.infinity,
                  height: 50,
                ),
                // ... similar for Facebook button ...
                 SizedBox(height: screenHeight * 0.05),

                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/create_account');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Modify helper widgets to accept theme or context
  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    required double width,
    required double height,
    required BuildContext contextForTheme, // Added
  }) {
    final theme = Theme.of(contextForTheme);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [AppColors.darkGradientStart, AppColors.darkGradientEnd]
              : [AppColors.lightGradientStart, AppColors.lightGradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: theme.textTheme.labelLarge, // Use theme button text style
        ),
        child: Text(text), // Text color should come from textStyle
      ),
    );
  }

 Widget _buildSocialButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    required Color iconColor, // Keep specific brand color for icon
    required BuildContext contextForTheme, // Added
    required double width,
    required double height,
  }) {
    final theme = Theme.of(contextForTheme);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton.icon(
        icon: Icon(icon, color: iconColor, size: 28),
        label: Text(text, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface)),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDarkMode ? AppColors.darkSocialButtonOutline : AppColors.lightSocialButtonOutline,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
  // ... rest of the class
}