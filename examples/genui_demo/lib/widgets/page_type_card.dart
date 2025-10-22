import 'package:flutter/material.dart';
import '../models/page_type.dart';

/// 页面类型选择卡片组件
class PageTypeCard extends StatelessWidget {
  final String pageType;
  final bool isSelected;
  final VoidCallback onTap;

  const PageTypeCard({
    super.key,
    required this.pageType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 2,
      color: isSelected 
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PageType.getIcon(pageType),
                size: 48,
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                PageType.getDisplayName(pageType),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: isSelected 
                      ? FontWeight.bold 
                      : FontWeight.normal,
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}