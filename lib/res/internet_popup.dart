import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/main.dart';

class InternetChecker {
  static StreamSubscription? _subscription;
  static bool _isDialogShowing = false;

  static void init() {
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final hasInternet = results.any((r) => r != ConnectivityResult.none);

      if (!hasInternet && !_isDialogShowing) {
        _showNoInternetDialog();
      } else if (hasInternet && _isDialogShowing) {
        _dismissDialog();
      }
    });
  }

  static void dispose() {
    _subscription?.cancel();
  }
  static void _showNoInternetDialog() {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (_) => PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Top emoji + animated ring ──
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFF0F0),
                    border: Border.all(
                      color: Colors.red.shade200,
                      width: 2.5,
                    ),
                  ),
                  child: const Center(
                    child: Text("📡", style: TextStyle(fontSize: 44)),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Title ──
                const Text(
                  "😕 Oops! No Internet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),

                // ── Message ──
                Text(
                  "Looks like you're offline 🌐\nPlease check your WiFi or\nmobile data and try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: Colors.grey.shade600,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 22),

                // ── Status chips row ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _statusChip("📶 WiFi", Colors.blue),
                    const SizedBox(width: 10),
                    _statusChip("📱 Mobile Data", Colors.orange),
                  ],
                ),
                const SizedBox(height: 22),

                // ── Waiting pill ──
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 11),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.amber.shade600,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "⏳ Waiting for connection...",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // ── Retry button ──
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      final results =
                      await Connectivity().checkConnectivity();
                      final hasNet =
                      results.any((r) => r != ConnectivityResult.none);
                      if (hasNet) _dismissDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D2B55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("🔄", style: TextStyle(fontSize: 18)),
                        SizedBox(width: 8),
                        Text(
                          "Try Again",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Tip text ──
                Text(
                  "💡 Tip: Auto-reconnects when internet is back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// ── Helper chip ──
  static Widget _statusChip(String label, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.shade200),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.5,
          color: color.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

// ── Dismiss ──
  static void _dismissDialog() {
    final context = navigatorKey.currentContext;
    if (context == null || !_isDialogShowing) return;
    _isDialogShowing = false;
    Navigator.of(context, rootNavigator: true).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Text("✅", style: TextStyle(fontSize: 16)),
            SizedBox(width: 10),
            Text(
              "Back online! You're connected 🎉",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade500,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}