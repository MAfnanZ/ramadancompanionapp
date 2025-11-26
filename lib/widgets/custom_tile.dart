import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final String title;
  final String trailing;
  final String? subtitle;
  const CustomTile({
    super.key,
    required this.title,
    required this.trailing,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white70,
      ),
      child: ListTile(
        title: Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
              )
            : null,
        trailing: Text(
          trailing,
          style: textTheme.titleMedium?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
