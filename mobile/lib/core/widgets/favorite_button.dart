import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Shared favorite toggle button widget
/// Displays a filled or outline heart icon based on [isFavorite] state
/// Animates with a scale pop effect when toggled
class FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback? onToggle;
  final double size;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    this.onToggle,
    this.size = 24,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onToggle,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Icon(
            widget.isFavorite ? Icons.favorite : Icons.favorite_outline,
            key: ValueKey(widget.isFavorite),
            size: widget.size,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
