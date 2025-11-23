import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cs_310_project/models/outfit_model.dart';

class OutfitItem extends StatelessWidget {
  final Outfit outfit;
  final VoidCallback? onTap;
  final bool draggable;
  final bool compact;

  const OutfitItem({
    super.key,
    required this.outfit,
    this.onTap,
    this.draggable = false,
    this.compact = false,
  });

  Widget _buildImage(String path, {double? width, double? height}) {
    if (path.startsWith('assets/') || path.startsWith('lib/')) {
      return Image.asset(path, width: width, height: height, fit: BoxFit.cover);
    }
    return Image.file(File(path), width: width, height: height, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    if (draggable) {
      return Draggable<Outfit>(
        data: outfit,
        feedback: Material(
          color: Colors.transparent,
          child: _buildContent(context),
        ),
        childWhenDragging: Opacity(
          opacity: 0.35,
          child: _buildContent(context),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: _buildContent(context),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: _buildContent(context),
    );
  }

  // ANA WIDGET
  Widget _buildContent(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (compact) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: scheme.outlineVariant),
        ),
        clipBehavior: Clip.hardEdge,
        child: _buildImage(outfit.imagePath),
      );
    }

    final size = MediaQuery.sizeOf(context);

    return Container(
      width: size.width / 1.1,
      height: size.height / 8.5,
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outlineVariant, width: 0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.15),
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
                outfit.imagePath,
                width: size.width / 4,
                height: double.infinity,
              ),
            ),
          ),
          Expanded(
            child: Text(
              outfit.name,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleMedium?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
