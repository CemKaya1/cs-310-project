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
    final Size screenSize = MediaQuery.sizeOf(context);
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // --- İçerik tasarımı (ClosetItem tarzı) ---
    final card = Container(
      width: screenWidth / 1.1,
      height: screenHeight / 8.5,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.8, color: Colors.grey.shade400),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
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
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                outfit.imagePath,
                width: screenWidth / 4,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                outfit.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );

    // --- Sürüklenebilir mod (Planner için) ---
    if (draggable) {
      return Draggable<Outfit>(
        data: outfit,
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(width: screenWidth / 1.1, child: card),
        ),
        childWhenDragging: Opacity(opacity: 0.4, child: card),
        child: GestureDetector(onTap: onTap, child: card),
      );
    }

    return GestureDetector(onTap: onTap, child: card);
  }
}
