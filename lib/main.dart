import 'package:flutter/material.dart';

/// Entry point of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: AnimatedDock<Map<String, dynamic>>(
            items: const [
              {'icon': Icons.person, 'label': 'Person'},
              {'icon': Icons.message, 'label': 'Message'},
              {'icon': Icons.call, 'label': 'Call'},
              {'icon': Icons.camera, 'label': 'Camera'},
              {'icon': Icons.photo, 'label': 'Photo'},
            ],
            builder: (item, isDragging, isHovered) {
              final icon = item['icon'] as IconData;
              final label = item['label'] as String;
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
            },
          ),
        ),
      ),
    );
  }
}

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
