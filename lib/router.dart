import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meat_shop/customers/home.dart';
import 'package:meat_shop/owner/signin.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    // Customer / public screen
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const MeatShopScreen();
      },
    ),

    // Admin login
    GoRoute(
      path: '/admins',
      builder: (context, state) {
        return const AdminSignInScreen();
      },
    ),
  ],

  // Show a simple 404 page for unknown routes
  errorBuilder: (context, state) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '404',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Page not found'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  },
);
