import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Defines the visual style of the button
enum BlaButtonStyle {
  /// Primary filled button with background color
  filled,

  /// Secondary outlined button with border
  outlined,
}

class BlaButton extends StatelessWidget {
  /// The text label displayed on the button
  final String label;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Visual style of the button (filled or outlined)
  final BlaButtonStyle style;

  /// Optional leading icon
  final Widget? icon;

  /// Creates a BlaButton with the specified properties.
  ///
  /// The [label] parameter is required.
  /// By default:
  /// - [style] is set to [BlaButtonStyle.filled]
  /// - [onPressed] is null (disabled state)
  /// - [icon] is null (no icon)
  const BlaButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = BlaButtonStyle.filled,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFilled = style == BlaButtonStyle.filled;
    final Color labelAndIconColor =
        isFilled ? BlaColors.white : BlaColors.primary;
    final Color backgroundColor =
        isFilled ? BlaColors.primary : BlaColors.white;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          vertical: BlaSpacings.m,
          horizontal: BlaSpacings.xxl,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BlaSpacings.radiusLarge),
        ),
        side: isFilled ? null : BorderSide(color: BlaColors.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(
                color: labelAndIconColor,
                size: 24.0,
              ),
              child: icon!,
            ),
            const SizedBox(width: BlaSpacings.m),
          ],
          Text(
            label,
            style: BlaTextStyles.button.copyWith(
              color: labelAndIconColor,
            ),
          ),
        ],
      ),
    );
  }
}
