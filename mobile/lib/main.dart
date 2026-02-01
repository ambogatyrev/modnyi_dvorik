import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ModnyiDvorikApp());
}

class ModnyiDvorikApp extends StatelessWidget {
  const ModnyiDvorikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Модный дворик',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const PlaceholderHomeScreen(),
    );
  }
}

class PlaceholderHomeScreen extends StatelessWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Модный дворик'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Модный дворик',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Женская одежда и аксессуары',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Загрузка...',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
