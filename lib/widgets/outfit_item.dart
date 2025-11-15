import 'package:flutter/material.dart';
import 'package:cs_310_project/core/constants/app_colors.dart';
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
        child: GestureDetector(onTap: onTap, child: _buildContent(context)),
      );
    }

    return GestureDetector(onTap: onTap, child: _buildContent(context));
  }

  // ============================================================
  //   ANA WİDGET – COMPACT ve NORMAL mod
  // ============================================================
  Widget _buildContent(BuildContext context) {
    if (compact) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        clipBehavior: Clip.hardEdge,
        child: Image.asset(
          outfit.imagePath,
          fit: BoxFit.cover,
        ),
      );
    }

    final Size size = MediaQuery.sizeOf(context);

    return Container(
      width: size.width / 1.1,
      height: size.height / 8.5,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.8, color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                outfit.imagePath,
                width: size.width / 4,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Text(
              outfit.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
