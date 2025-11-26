import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final String trailing;
  final Color? trailingColor;
  final String? subtitle;
  final Color? subtitleColor;
  final Color? backgroundColor;
  const CustomTile({
    super.key,
    required this.title,
    required this.trailing,
    this.subtitle,
    this.titleColor = Colors.black,
    this.backgroundColor = Colors.white70,
    this.trailingColor = Colors.black,
    this.subtitleColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: backgroundColor,
      ),
      child: ListTile(
        title: Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            color: titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: textTheme.bodyLarge
                    ?.copyWith(color: subtitleColor),
              )
            : null,
        trailing: Text(
          trailing,
          style: textTheme.titleMedium?.copyWith(
            color: trailingColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
