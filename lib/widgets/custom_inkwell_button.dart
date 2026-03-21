import 'package:flutter/material.dart';

class CustomInkWellButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final bool isLoading;
  final double height;
  final Border? border;
  final double borderRadius;

  const CustomInkWellButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.deepOrange,
    this.textColor = Colors.white,
    this.icon,
    this.isLoading = false,
    this.height = 50,
    this.border,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonWidget = Container(
      height: height,
      decoration: BoxDecoration(
        color: isLoading ? backgroundColor.withValues(alpha: 0.7) : backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: border,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
                strokeWidth: 2,
              ),
            )
          else ...[
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        splashColor: textColor.withValues(alpha: 0.1),
        highlightColor: textColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(borderRadius),
        child: buttonWidget,
      ),
    );
  }
}
