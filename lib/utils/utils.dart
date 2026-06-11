// import 'package:flutter/material.dart';
// import 'dart:async';
//
// import '../main.dart';
//
// class Utils {
//   static OverlayEntry? _overlayEntry;
//   static bool _isShowing = false;
//
//   // ===================== TEXT TOAST =====================
//
//   static void show(String message, BuildContext context, {List<Color>? colors}) {
//     final overlay = Overlay.of(context);
//     if (overlay == null) return;
//
//     if (_isShowing) {
//       _overlayEntry?.remove();
//     }
//
//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         top: MediaQuery.of(context).padding.top + 20,
//         left: 20,
//         right: 20,
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: colors ??
//                     const [
//                       Color(0xff4facfe),
//                       Color(0xff00f2fe),
//                     ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.28),
//                   blurRadius: 14,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: Text(
//               message,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14.5,
//                 fontWeight: FontWeight.w600,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       ),
//     );
//
//     overlay.insert(_overlayEntry!);
//     _isShowing = true;
//
//     _startTimer();
//   }
//
//   static void _startTimer() {
//     Timer(const Duration(seconds: 2), () {
//       if (_overlayEntry?.mounted ?? false) {
//         _overlayEntry!.remove();
//         _overlayEntry = null;
//         _isShowing = false;
//       }
//     });
//   }
//
//   // ===================== IMAGE TOAST =====================
//
//   static OverlayEntry? _overlayImgEntry;
//   static bool _isShowingImg = false;
//
//   static void showImage(
//       String imagePath,
//       BuildContext context, {
//         int duration = 2,
//       }) {
//     final overlay = Overlay.of(context);
//     if (overlay == null) return;
//
//     if (_isShowingImg) {
//       _overlayImgEntry?.remove();
//     }
//
//     _overlayImgEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         bottom: MediaQuery.of(context).viewInsets.bottom + 50,
//         left: 25,
//         right: 25,
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             height: screenWidth * 0.22,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(18),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.25),
//                   blurRadius: 18,
//                   offset: const Offset(0, 8),
//                 ),
//               ],
//               image: DecorationImage(
//                 image: AssetImage(imagePath),
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//
//     overlay.insert(_overlayImgEntry!);
//     _isShowingImg = true;
//
//     _startImgTimer(duration);
//   }
//
//   static void _startImgTimer(int duration) {
//     Timer(Duration(seconds: duration), () {
//       if (_overlayImgEntry?.mounted ?? false) {
//         _overlayImgEntry!.remove();
//         _overlayImgEntry = null;
//         _isShowingImg = false;
//       }
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'dart:async';

import '../main.dart';
import '../res/app_color.dart';

class Utils {
  // ─── Text Toast ──────────────────────────────────────────────────────────────

  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;
  static Timer? _timer;

  /// Shows a stylish top toast with optional gradient colors and type.
  /// [type] can be: 'success', 'error', 'warning', 'info' (default)
  static void show(
      String message,
      BuildContext context, {
        List<Color>? colors,
        String type = 'info',
        int duration = 2,
        IconData? icon,
      }) {
    final overlay = Overlay.of(context);

    if (_isShowing) {
      _timer?.cancel();
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isShowing = false;
    }

    // ── pick theme from type ──
    final _ToastTheme theme = _ToastTheme.fromType(type, colors);

    _overlayEntry = OverlayEntry(
      builder: (ctx) => _AnimatedToast(
        message: message,
        theme: theme,
        icon: icon ?? theme.icon,
      ),
    );

    overlay.insert(_overlayEntry!);
    _isShowing = true;
    _timer = Timer(Duration(seconds: duration + 1), _dismissText);
  }

  static void _dismissText() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isShowing = false;
  }

  // ─── Image Toast ─────────────────────────────────────────────────────────────

  static OverlayEntry? _overlayImgEntry;
  static bool _isShowingImg = false;
  static Timer? _imgTimer;

  static void showImage(
      String imagePath,
      BuildContext context, {
        int duration = 2,
        String? label,
      }) {
    final overlay = Overlay.of(context);

    if (_isShowingImg) {
      _imgTimer?.cancel();
      _overlayImgEntry?.remove();
      _overlayImgEntry = null;
      _isShowingImg = false;
    }

    _overlayImgEntry = OverlayEntry(
      builder: (ctx) => _AnimatedImageToast(
        imagePath: imagePath,
        label: label,
      ),
    );

    overlay.insert(_overlayImgEntry!);
    _isShowingImg = true;
    _imgTimer = Timer(Duration(seconds: duration + 1), _dismissImage);
  }

  static void _dismissImage() {
    _overlayImgEntry?.remove();
    _overlayImgEntry = null;
    _isShowingImg = false;
  }
}

// ─── Toast Theme Model ───────────────────────────────────────────────────────

class _ToastTheme {
  final List<Color> colors;
  final IconData icon;
  final Color iconBg;

  const _ToastTheme({
    required this.colors,
    required this.icon,
    required this.iconBg,
  });

  factory _ToastTheme.fromType(String type, List<Color>? customColors) {
    switch (type) {
      case 'success':
        return _ToastTheme(
          colors: customColors ?? [const Color(0xFF00B09B), const Color(0xFF96C93D)],
          icon: Icons.check_circle_rounded,
          iconBg: Colors.white.withOpacity(0.22),
        );
      case 'error':
        return _ToastTheme(
          colors: customColors ?? [const Color(0xFFCB2D3E), const Color(0xFFEF473A)],
          icon: Icons.cancel_rounded,
          iconBg: Colors.white.withOpacity(0.22),
        );
      case 'warning':
        return _ToastTheme(
          colors: customColors ?? [const Color(0xFFF7971E), const Color(0xFFFFD200)],
          icon: Icons.warning_amber_rounded,
          iconBg: Colors.white.withOpacity(0.22),
        );
      case 'info':
      default:
        return _ToastTheme(
          colors: customColors ?? [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
          icon: Icons.info_rounded,
          iconBg: Colors.white.withOpacity(0.22),
        );
    }
  }
}

// ─── Animated Text Toast Widget ──────────────────────────────────────────────

class _AnimatedToast extends StatefulWidget {
  final String message;
  final _ToastTheme theme;
  final IconData icon;

  const _AnimatedToast({
    required this.message,
    required this.theme,
    required this.icon,
  });

  @override
  State<_AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<_AnimatedToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));

    _fade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.5)));

    _ctrl.forward();

    // auto dismiss slide out
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) _ctrl.reverse();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.lightBlueColor,
                    AppColor.lightBlueColor.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: widget.theme.colors.last.withOpacity(0.38),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon container
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.icon,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  // Message
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Animated Image Toast Widget ─────────────────────────────────────────────

class _AnimatedImageToast extends StatefulWidget {
  final String imagePath;
  final String? label;

  const _AnimatedImageToast({required this.imagePath, this.label});

  @override
  State<_AnimatedImageToast> createState() => _AnimatedImageToastState();
}

class _AnimatedImageToastState extends State<_AnimatedImageToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 1.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));

    _fade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.5)));

    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));

    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) _ctrl.reverse();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom + 50,
      left: 24,
      right: 24,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top accent bar
                    Container(
                      height: 3,
                      margin:  EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColor.lightBlueColor,
                            AppColor.lightBlueColor.withValues(alpha: 0.85),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    // Image
                    SizedBox(
                      height: screenWidth * 0.22,
                      child: Image.asset(
                        widget.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Optional label
                    if (widget.label != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.label!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}