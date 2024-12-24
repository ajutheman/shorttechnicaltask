
import 'package:flutter/material.dart';
import 'package:shorttechnicaltask/widgets/dock_item.dart';
import 'widgets/animated_dock.dart';
import 'models/dock_item_model.dart';

/// Entry point of the application.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 254, 254),
        body: Center(
          child: AnimatedDock<DockItemModel>(
            items: const [
              DockItemModel(icon: Icons.person, label: 'Person'),
              DockItemModel(icon: Icons.message, label: 'Message'),
              DockItemModel(icon: Icons.call, label: 'Call'),
              DockItemModel(icon: Icons.camera, label: 'Camera'),
              DockItemModel(icon: Icons.photo, label: 'Photo'),
            ],
            builder: (item, isDragging, isHovered) {
              return DockItem(
                icon: item.icon,
                label: item.label,
                isDragging: isDragging,
                isHovered: isHovered,
              );
            },
          ),
        ),
      ),
    );
  }
}
