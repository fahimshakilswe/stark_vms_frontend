import 'package:flutter/material.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';

class SidebarItemData {
  final String title;
  final IconData icon;
  final String route;
  final String? badge;

  const SidebarItemData({
    required this.title,
    required this.icon,
    required this.route,
    this.badge,
  });
}

class SidebarItemWidget extends StatelessWidget {
  final SidebarItemData item;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback onTap;

  const SidebarItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    this.isCollapsed = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? AppColors.sidebarSelected : Colors.transparent;
    final fg = isSelected ? Colors.white : AppColors.sidebarForeground.withValues(alpha: 0.8);
    final iconColor = isSelected ? AppColors.accent : AppColors.sidebarForeground.withValues(alpha: 0.65);

    if (isCollapsed) {
      return Tooltip(
        message: item.title,
        waitDuration: const Duration(milliseconds: 300),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Material(
            color: bg,
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: onTap,
              hoverColor: Colors.white.withValues(alpha: 0.05),
              child: Container(
                height: 42,
                alignment: Alignment.center,
                child: Icon(item.icon, size: 20, color: iconColor),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          hoverColor: Colors.white.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(item.icon, size: 19, color: iconColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: fg,
                      fontSize: 13.5,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (item.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent : Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
