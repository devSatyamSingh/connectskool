import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  1. InternetService  (singleton, NO plugin)
// ─────────────────────────────────────────────
class InternetService {
  InternetService._();
  static final InternetService instance = InternetService._();

  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get onStatusChange => _controller.stream;

  // NULL rakha hai taaki pehli baar hamesha event fire ho
  bool? _isConnected;
  bool get isConnected => _isConnected ?? true;

  Timer? _timer;

  Future<void> init() async {
    // Pehli check AWAIT karo — app build hone se PEHLE result aaye
    await _check();
    // Phir har 3 second pe check karte raho
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _check());
  }

  Future<void> _check() async {
    bool connected;
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 4));
      connected = result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      connected = false;
    }

    // Pehli baar ya status change hone par hi event bhejo
    if (connected != _isConnected) {
      _isConnected = connected;
      _controller.add(connected);
    }
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}


class InternetAwareWrapper extends StatefulWidget {
  final Widget child;
  const InternetAwareWrapper({super.key, required this.child});

  @override
  State<InternetAwareWrapper> createState() => _InternetAwareWrapperState();
}

class _InternetAwareWrapperState extends State<InternetAwareWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  bool _showBanner = false;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack);

    // Stream listen — jab bhi status change ho
    InternetService.instance.onStatusChange.listen((connected) {
      if (!mounted) return;
      setState(() {
        _isConnected = connected;
        _showBanner = true;
      });
      _animCtrl.forward(from: 0);

      // Online hone par 3 second baad auto-hide
      if (connected) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _showBanner = false);
        });
      }
    });

    // App open hote waqt agar net already off hai toh turant banner dikhao
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!InternetService.instance.isConnected) {
        setState(() {
          _isConnected = false;
          _showBanner = true;
        });
        _animCtrl.forward(from: 0);
      }
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        widget.child,
        if (_showBanner)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _NoInternetBanner(
              isConnected: _isConnected,
              scaleAnim: _scaleAnim,
              onDismiss: () => setState(() => _showBanner = false),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  3. Banner Widget
// ─────────────────────────────────────────────
class _NoInternetBanner extends StatelessWidget {
  final bool isConnected;
  final Animation<double> scaleAnim;
  final VoidCallback onDismiss;

  const _NoInternetBanner({
    required this.isConnected,
    required this.scaleAnim,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final color = isConnected
        ? const Color(0xFF2ECC71)
        : const Color(0xFFE74C3C);
    final icon  = isConnected ? Icons.wifi : Icons.wifi_off_rounded;
    final title = isConnected ? 'Back Online!' : 'No Internet Connection';
    final msg   = isConnected
        ? 'Your connection has been restored.'
        : 'Please check your Wi-Fi or mobile data.';

    return ScaleTransition(
      scale: scaleAnim,
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.45),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        msg,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.88),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isConnected)
                  GestureDetector(
                    onTap: onDismiss,
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withOpacity(0.8),
                      size: 18,
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