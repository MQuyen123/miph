import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Server selector widget — Tab bar để chọn server phát phim
class ServerSelector extends StatelessWidget {
  final List<String> serverNames;
  final int currentServerIndex;
  final ValueChanged<int> onServerChanged;

  const ServerSelector({
    super.key,
    required this.serverNames,
    required this.currentServerIndex,
    required this.onServerChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (serverNames.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Nguồn phát',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(serverNames.length, (index) {
                final isSelected = index == currentServerIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(
                      serverNames[index].isNotEmpty
                          ? serverNames[index]
                          : 'Server ${index + 1}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => onServerChanged(index),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.cardDark,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.white12,
                      width: 0.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
