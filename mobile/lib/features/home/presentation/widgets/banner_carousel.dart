import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Banner carousel widget with auto-rotation
/// Displays promotional banners with dots indicator
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  // Banner data with images
  final List<String> _banners = [
    'assets/images/image7.png',
    'assets/images/image8.png',
    'assets/images/image9.png',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Banner PageView
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              return _buildBannerItem(_banners[index]);
            },
          ),
        ),

        const SizedBox(height: 12),

        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) => _buildDot(index)),
        ),
      ],
    );
  }

  Widget _buildBannerItem(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.border,
            child: Center(
              child: Icon(
                Icons.image_not_supported,
                color: AppColors.textSecondary,
                size: 48,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.secondary : AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
