import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meat_shop/design/design.dart';

class AdminSignInScreen extends StatefulWidget {
  const AdminSignInScreen({super.key});

  @override
  State<AdminSignInScreen> createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // AUTHENTICATE USER
  // ===========================================================================

  Future<void> _authenticate() async {
    if (_isLoading) return;

    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    // -------------------------------------------------------------------------
    // Remove +91 / spaces / hyphens from phone number
    // -------------------------------------------------------------------------

    String cleanPhone = phone
        .replaceAll('+91', '')
        .replaceAll(' ', '')
        .replaceAll('-', '');

    // -------------------------------------------------------------------------
    // Validate phone number
    // -------------------------------------------------------------------------

    if (!RegExp(r'^\d{10}$').hasMatch(cleanPhone)) {
      _showMessage('Enter a valid 10-digit phone number.');
      return;
    }

    // -------------------------------------------------------------------------
    // Validate password
    // -------------------------------------------------------------------------

    if (password.isEmpty) {
      _showMessage('Enter your password.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // -----------------------------------------------------------------------
      // Get users collection
      //
      // shop
      //   └── basicinfo
      //       └── users
      // -----------------------------------------------------------------------

      final usersSnapshot = await FirebaseFirestore.instance
          .collection('shop')
          .doc('basicinfo')
          .collection('users')
          .get();

      bool authenticated = false;

      // -----------------------------------------------------------------------
      // Compare entered number/password with every user document
      // -----------------------------------------------------------------------

      for (final document in usersSnapshot.docs) {
        final data = document.data();

        final storedNumber = data['number']?.toString().trim() ?? '';

        final storedPassword = data['password']?.toString() ?? '';

        if (storedNumber == cleanPhone && storedPassword == password) {
          authenticated = true;
          break;
        }
      }

      if (!mounted) return;

      if (authenticated) {
        _showMessage('Auth passed', isSuccess: true);
      } else {
        _showMessage('Auth failed', isSuccess: false);
      }
    } on FirebaseException catch (e) {
      if (!mounted) return;

      _showMessage(
        'Authentication error: ${e.message ?? e.code}',
        isSuccess: false,
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage('Auth failed', isSuccess: false);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ===========================================================================
  // MESSAGE
  // ===========================================================================

  void _showMessage(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isSuccess ? AppColors.primary : null,
        ),
      );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.margin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _StaffPortalHeader(),

                  const SizedBox(height: AppSpacing.gutter),

                  _buildSignInCard(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SIGN IN CARD
  // ===========================================================================

  Widget _buildSignInCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.margin * 1.25),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------------------------------------------------------
          // TITLE
          // -------------------------------------------------------------------
          Text(
            'Admin Sign In',
            style: AppTypography.headlineLg.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppSpacing.spaceXs),

          Text(
            'Enter credentials to unlock terminal registers and cutting logs.',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),

          const SizedBox(height: AppSpacing.spaceLg),

          // -------------------------------------------------------------------
          // PHONE NUMBER
          // -------------------------------------------------------------------
          Text(
            'Phone Number',
            style: AppTypography.labelLg.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSpacing.spaceSm),

          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            enabled: !_isLoading,
            style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w600),
            decoration: _buildInputDecoration(prefixIcon: Icons.phone_outlined),
          ),

          const SizedBox(height: AppSpacing.spaceLg),

          // -------------------------------------------------------------------
          // PASSWORD
          // -------------------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Password',
                style: AppTypography.labelLg.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),

              GestureDetector(
                onTap: _isLoading
                    ? null
                    : () {
                        // Forgot password
                      },
                child: Text(
                  'Forgot?',
                  style: AppTypography.labelLg.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.spaceSm),

          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            enabled: !_isLoading,
            style: AppTypography.bodyLg.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: _obscurePassword ? 2.0 : 0.0,
            ),
            decoration: _buildInputDecoration(
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.remove_red_eye_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: _isLoading
                    ? null
                    : () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.spaceXl),

          // -------------------------------------------------------------------
          // SIGN IN BUTTON
          // -------------------------------------------------------------------
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _authenticate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onPrimary,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign In',
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(width: 8),

                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.onPrimary,
                          size: 22,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // INPUT DECORATION
  // ===========================================================================

  InputDecoration _buildInputDecoration({
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 16, right: 12),
        child: Icon(prefixIcon, color: AppColors.onSurfaceVariant, size: 20),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}

// =============================================================================
// STAFF PORTAL TOP BAR
// =============================================================================

class _StaffPortalHeader extends StatelessWidget {
  const _StaffPortalHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.onSurface,
                size: 20,
              ),
            ),
          ),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.restaurant_menu_rounded,
                    color: AppColors.onPrimary,
                    size: 18,
                  ),
                ),

                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'The Meat Shop',
                      style: AppTypography.headlineSm.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),

                    Text(
                      'STAFF PORTAL',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.secondary,
                        fontSize: 10,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
