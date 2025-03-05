import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomAngleMenu extends StatefulWidget {
  final IconData mainIcon;
  final Color mainButtonColor;
  final List<CustomMenuItem> menuItems;

  const CustomAngleMenu({
    super.key,
    this.mainIcon = Icons.leaderboard_outlined,
    this.mainButtonColor = Colors.deepPurple,
    required this.menuItems,
  });

  @override
  State<CustomAngleMenu> createState() => _CustomAngleMenuState();
}

class _CustomAngleMenuState extends State<CustomAngleMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  void _toggleMenu() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Option Buttons with Animation
        ...widget.menuItems.map((item) => _buildOptionButton(item)).toList(),

        // Main Button
        GestureDetector(
          onTap: _toggleMenu,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.mainButtonColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(
              widget.mainIcon,
              color: Colors.deepPurple.shade300,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  /// Generates each menu button with an animation.
  Widget _buildOptionButton(CustomMenuItem item) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double dx = item.distance *
            _animation.value *
            math.cos(item.angle * math.pi / 180);
        final double dy = item.distance *
            _animation.value *
            math.sin(item.angle * math.pi / 180);

        return Positioned(
          left: dx,
          top: -dy,
          child: Transform.scale(
            scale: _animation.value,
            child: Opacity(
              opacity: _animation.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      item.onTap();
                      _controller.reverse();
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(5),
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            item.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Menu Item Model
class CustomMenuItem {
  final double angle; // Angle in degrees
  final double distance; // Distance from the main button
  final String imagePath; // Image path instead of icon
  final VoidCallback onTap;

  CustomMenuItem({
    required this.angle,
    this.distance = 80,
    required this.imagePath,
    required this.onTap,
  });
}
