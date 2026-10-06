import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meat_shop/design/design.dart';

class MeatShopScreen extends StatelessWidget {
  const MeatShopScreen({super.key});

  Future<Map<String, dynamic>> _loadShopData() async {
    final firestore = FirebaseFirestore.instance;

    try {
      final results = await Future.wait([
        firestore.collection('shop').doc('basicinfo').get(),
        firestore.collection('shop').doc('inventory').get(),
      ]).timeout(const Duration(seconds: 15));

      final basicInfoSnapshot =
          results[0] as DocumentSnapshot<Map<String, dynamic>>;

      final inventorySnapshot =
          results[1] as DocumentSnapshot<Map<String, dynamic>>;

      if (!basicInfoSnapshot.exists) {
        throw Exception('The shop/basicinfo document does not exist.');
      }

      if (!inventorySnapshot.exists) {
        throw Exception('The shop/inventory document does not exist.');
      }

      return {
        'basicinfo': basicInfoSnapshot.data() ?? {},
        'inventory': inventorySnapshot.data() ?? {},
      };
    } on FirebaseException catch (e) {
      throw Exception('Firebase error: ${e.code} - ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: FutureBuilder<Map<String, dynamic>>(
              future: _loadShopData(),
              builder: (context, snapshot) {
                // ----------------------------------------------------------
                // LOADING
                // ----------------------------------------------------------

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ----------------------------------------------------------
                // ERROR
                // ----------------------------------------------------------

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline_rounded, size: 48),

                          const SizedBox(height: 16),

                          Text(
                            'Unable to load shop',
                            style: AppTypography.headlineSm.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 8),

                          Text(
                            snapshot.error.toString(),
                            style: AppTypography.bodyMd,
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const MeatShopScreen(),
                                ),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // ----------------------------------------------------------
                // NO DATA
                // ----------------------------------------------------------

                if (!snapshot.hasData) {
                  return const Center(child: Text('No shop data found.'));
                }

                final result = snapshot.data!;

                final basicInfo = Map<String, dynamic>.from(
                  result['basicinfo'] as Map,
                );

                final inventory = Map<String, dynamic>.from(
                  result['inventory'] as Map,
                );

                // ----------------------------------------------------------
                // BASIC INFO
                // ----------------------------------------------------------

                final String shopName =
                    basicInfo['name']?.toString() ?? 'The Meat Shop';

                final String phone = basicInfo['number']?.toString() ?? '';

                final String email = basicInfo['email']?.toString() ?? '';

                final String address = basicInfo['address']?.toString() ?? '';

                // ----------------------------------------------------------
                // SCREEN
                // ----------------------------------------------------------

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.margin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _HeaderCard(shopName: shopName),

                            const SizedBox(height: AppSpacing.gutter),

                            _AvailableMeatsCard(inventory: inventory),

                            const SizedBox(height: AppSpacing.gutter),

                            _ContactUsCard(
                              address: address,
                              phone: phone,
                              email: email,
                            ),

                            const SizedBox(height: AppSpacing.spaceLg),
                          ],
                        ),
                      ),
                    ),

                    const _BuyNowBottomBar(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// HEADER CARD
// =============================================================================

class _HeaderCard extends StatelessWidget {
  final String shopName;

  const _HeaderCard({required this.shopName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant_menu_rounded,
              color: AppColors.onPrimary,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              shopName,
              textAlign: TextAlign.center,
              style: AppTypography.headlineMd.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),

          Container(
            width: 40,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// AVAILABLE MEATS
// =============================================================================

class _AvailableMeatsCard extends StatelessWidget {
  final Map<String, dynamic> inventory;

  const _AvailableMeatsCard({required this.inventory});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.margin),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Text(
            'Available meats',
            style: AppTypography.headlineMd.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppSpacing.margin),

          if (inventory.isEmpty)
            Text(
              'No meats available',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            )
          else
            ...inventory.entries.map((entry) {
              final value = entry.value;

              String price = '';
              String unit = '/ kg';

              if (value is Map) {
                price = value['price']?.toString() ?? '';

                unit = value['unit']?.toString() ?? '/ kg';
              } else {
                price = value.toString();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.spaceSm),
                child: _MeatPriceTile(
                  title: entry.key,
                  price: price,
                  unit: unit,
                ),
              );
            }),
        ],
      ),
    );
  }
}

// =============================================================================
// MEAT PRICE TILE
// =============================================================================

class _MeatPriceTile extends StatelessWidget {
  final String title;
  final String price;
  final String unit;

  const _MeatPriceTile({
    required this.title,
    required this.price,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w600),
            ),
          ),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: price,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                TextSpan(
                  text: ' $unit',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CONTACT US CARD
// =============================================================================

class _ContactUsCard extends StatelessWidget {
  final String address;
  final String phone;
  final String email;

  const _ContactUsCard({
    required this.address,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.margin),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contact Us',
                style: AppTypography.headlineMd.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              Text(
                'SHOP',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.margin),

          _ContactInfoContainer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _CircleIconAvatar(icon: Icons.location_on_outlined),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ADDRESS',
                        style: AppTypography.labelCaps.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        address.isEmpty ? 'Address not available' : address,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.onSurface,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.north_east_rounded,
                  size: 18,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.spaceSm),

          _ContactInfoContainer(
            child: Row(
              children: [
                const _CircleIconAvatar(icon: Icons.phone_outlined),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PHONE',
                        style: AppTypography.labelCaps.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        phone.isEmpty ? 'Phone number not available' : phone,
                        style: AppTypography.bodyLg.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.spaceSm),

          _ContactInfoContainer(
            child: Row(
              children: [
                const _CircleIconAvatar(icon: Icons.email_outlined),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EMAIL',
                        style: AppTypography.labelCaps.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        email.isEmpty ? 'Email not available' : email,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.spaceSm),

          _ContactInfoContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 18,
                  color: AppColors.onSurfaceVariant,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Daily: 07:00 AM – 08:30 PM ',
                          style: AppTypography.bodySm,
                        ),
                        const TextSpan(
                          text: '• ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'EXPRESS 45M DELIVERY',
                          style: AppTypography.labelCaps.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CONTACT INFO CONTAINER
// =============================================================================

class _ContactInfoContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _ContactInfoContainer({
    required this.child,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: child,
    );
  }
}

// =============================================================================
// CIRCLE ICON
// =============================================================================

class _CircleIconAvatar extends StatelessWidget {
  final IconData icon;

  const _CircleIconAvatar({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: AppColors.primary),
    );
  }
}

// =============================================================================
// BOTTOM ACTION BAR
// =============================================================================

class _BuyNowBottomBar extends StatelessWidget {
  const _BuyNowBottomBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.margin),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Buy Now',
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
    );
  }
}
