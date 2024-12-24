import 'package:flutter/material.dart';

/// Widget representing a single item in the dock.
class DockItem extends StatelessWidget {
  const DockItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isDragging,
    required this.isHovered,
  });

  final IconData icon;
  final String label;
  final bool isDragging;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: isHovered, // Show label only when hovered
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          width: isDragging || isHovered ? 70 : 48,
          height: isDragging || isHovered ? 70 : 48,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors
                .primaries[icon.hashCode % Colors.primaries.length],
            boxShadow: [
              if (isDragging)
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
              size: isDragging || isHovered ? 32 : 24,
            ),
          ),
        ),
      ],
    );
  }
}
