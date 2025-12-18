import 'package:flutter/material.dart';
import 'dart:io';

class ClosetItem extends StatelessWidget {
  final String imagePath;
  final String name;

  const ClosetItem({
    super.key,
    required this.imagePath,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.sizeOf(context);

    return Container(
      width: size.width / 1.1,
      height: size.height / 9,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildImage(
                imagePath,
                width: size.width / 4,
                height: double.infinity,
              ),
            ),
          ),

          Expanded(
            child: Text(
              name,
              style: textTheme.titleMedium?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String path, {required double width, required double height}) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(path, width: width, height: height, fit: BoxFit.cover);
    }
    if (path.startsWith('assets/') || path.startsWith('lib/')) {
      return Image.asset(path, width: width, height: height, fit: BoxFit.cover);
    }
    return Image.file(File(path), width: width, height: height, fit: BoxFit.cover);
  }
}
