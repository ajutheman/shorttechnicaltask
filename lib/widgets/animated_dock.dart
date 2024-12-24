import 'package:flutter/material.dart';

/// Dock with draggable and animated items.
class AnimatedDock<T extends Object> extends StatefulWidget {
  const AnimatedDock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this dock.
  final List<T> items;

  /// Builder to build the provided [T] item.
  final Widget Function(T, bool, bool) builder;

  @override
  State<AnimatedDock<T>> createState() => _AnimatedDockState<T>();
}

/// State for the [AnimatedDock].
class _AnimatedDockState<T extends Object> extends State<AnimatedDock<T>> {
  late final List<T> _items = widget.items.toList();
  T? _draggedItem;
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black38,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          _items.length,
          (index) {
            final item = _items[index];
            final isDragging = item == _draggedItem;
            final isHovered = _hoveredIndex == index;

            return MouseRegion(
              onEnter: (_) {
                setState(() {
                  _hoveredIndex = index;
                });
              },
              onExit: (_) {
                setState(() {
                  _hoveredIndex = -1;
                });
              },
              child: Draggable<T>(
                data: item,
                feedback: Material(
                  color: Colors.transparent,
                  child: widget.builder(item, true, false),
                ),
                onDragStarted: () {
                  setState(() {
                    _draggedItem = item;
                  });
                },
                onDragEnd: (_) {
                  setState(() {
                    _draggedItem = null;
                  });
                },
                childWhenDragging: const SizedBox.shrink(), // Hide the icon
                child: DragTarget<T>(
                  onWillAccept: (receivedItem) => receivedItem != item,
                  onAccept: (receivedItem) {
                    setState(() {
                      final currentIndex = _items.indexOf(receivedItem);
                      _items.removeAt(currentIndex);
                      _items.insert(index, receivedItem);
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return widget.builder(item, isDragging, isHovered);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
