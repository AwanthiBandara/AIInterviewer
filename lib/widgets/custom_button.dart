import 'package:aiinterviewer/constants/colors.dart';
import 'package:flutter/material.dart';

enum ButtonType { Medium, Small }

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color buttonColor;
  final Color textColor;
  final String buttonText;
  final ButtonType buttonType;
  final IconData? leadingIcon;
  final Color? iconColor;
  final double? iconSize;
  final bool enabled;

  const CustomButton({
    Key? key,
    required this.onTap,
    this.buttonColor = secondaryColor,
    this.textColor = white,
    required this.buttonText,
    this.buttonType = ButtonType.Medium,
    this.leadingIcon,
    this.iconColor,
    this.iconSize,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? buttonColor : cardTextColor, // Button background color
      borderRadius: BorderRadius.circular(buttonType == ButtonType.Medium ? 8 : 6),
      child: InkWell(
        onTap: enabled ? onTap : null,
        splashColor: Colors.white.withOpacity(0.2), // Clickable effect color
        borderRadius: BorderRadius.circular(buttonType == ButtonType.Medium ? 8 : 6),
        child: Container(
          height: buttonType == ButtonType.Medium ? 48 : 32,
          width: buttonType == ButtonType.Medium ? MediaQuery.of(context).size.width : null,
          padding: buttonType == ButtonType.Small ? EdgeInsets.symmetric(horizontal: 12) : null,
          decoration: BoxDecoration(
            color: Colors.transparent, // Transparent background to show InkWell effect
            borderRadius: BorderRadius.circular(buttonType == ButtonType.Medium ? 8 : 6),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    color: iconColor ?? textColor,
                    size: iconSize ?? 20,
                  ),
                  SizedBox(width: 8),
                ],
                Text(
                  buttonText,
                  style: TextStyle(
                    color: enabled ? textColor : Colors.white.withOpacity(0.5),
                    fontSize: buttonType == ButtonType.Medium ? 16 : 14,
                    fontWeight: FontWeight.bold,
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
