import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders one of the exact SVG vectors exported from Figma (see
/// [AppIcons]), optionally tinted to match the current color/state -
/// the source vectors are single-color strokes/fills, so tinting via
/// [ColorFilter] reproduces every Figma color variant from one asset.
class AppIcon extends StatelessWidget {
  const AppIcon(this.asset, {super.key, this.size = 24, this.color});

  final String asset;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
