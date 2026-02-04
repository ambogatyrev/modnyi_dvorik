import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

/// Custom search AppBar with iOS-style animations
/// - Search bar expands from left to right
/// - Cancel button slides in from right
/// - TextField auto-focuses when animation completes
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final Function(String) onQueryChanged;
  final VoidCallback onCancel;

  const SearchAppBar({
    super.key,
    required this.controller,
    required this.onQueryChanged,
    required this.onCancel,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _searchBarAnimation;
  late Animation<Offset> _cancelButtonSlideAnimation;
  late Animation<double> _cancelButtonFadeAnimation;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Search bar width animation (0 to 1)
    _searchBarAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    // Cancel button slide animation (from right)
    _cancelButtonSlideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
        );

    // Cancel button fade animation
    _cancelButtonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward().then((_) {
        // Auto-focus TextField after animation completes
        _focusNode.requestFocus();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleCancel() {
    // Clear the text field
    widget.controller.clear();

    // Call the cancel callback
    widget.onCancel();

    // Pop the screen
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            // Search bar with animation
            Expanded(
              child: AnimatedBuilder(
                animation: _searchBarAnimation,
                builder: (context, child) {
                  return SizeTransition(
                    sizeFactor: _searchBarAnimation,
                    axis: Axis.horizontal,
                    axisAlignment: -1,
                    child: child,
                  );
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.muted,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    onChanged: widget.onQueryChanged,
                    decoration: InputDecoration(
                      hintText: 'Поиск товаров...',
                      hintStyle: TextStyle(
                        color: AppColors.mutedForeground,
                        fontSize: 16,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          'assets/icons/search.svg',
                          colorFilter: const ColorFilter.mode(
                            AppColors.mutedForeground,
                            BlendMode.srcIn,
                          ),
                          width: 20,
                          height: 20,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      suffixIcon: widget.controller.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: AppColors.mutedForeground,
                                size: 20,
                              ),
                              onPressed: () {
                                widget.controller.clear();
                                widget.onQueryChanged('');
                              },
                            )
                          : null,
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),

            // Cancel button with slide and fade animation
            SlideTransition(
              position: _cancelButtonSlideAnimation,
              child: FadeTransition(
                opacity: _cancelButtonFadeAnimation,
                child: TextButton(
                  onPressed: _handleCancel,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: const Size(0, 40),
                  ),
                  child: Text(
                    'Отменить',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
