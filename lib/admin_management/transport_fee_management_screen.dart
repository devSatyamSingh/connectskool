import 'package:flutter/material.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import '../res/app_color.dart';
import '../res/const_text.dart';

class TransportFeeManagementScreen extends StatefulWidget {
  const TransportFeeManagementScreen({super.key});

  @override
  State<TransportFeeManagementScreen> createState() =>
      _TransportFeeManagementScreenState();
}

class _TransportFeeManagementScreenState
    extends State<TransportFeeManagementScreen> {

  List transportList = [
    {"route": "Route A", "amount": "1200"},
    {"route": "Route B", "amount": "1500"},
  ];

  TextEditingController routeController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBgColor,
      body: Column(
        children: [

          /// HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                    color: AppColor.blueShadow,
                    blurRadius: 18,
                    offset: const Offset(0, 10)),
              ],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColor.glassWhite,
                        shape: BoxShape.circle),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText.customText(
                    "Transport Fee Management",
                    size: 19,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// GRID MENU
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(12),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [

                /// ROUTE
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.routeScreen);
                  },
                  child: _gridCard(
                      icon: Icons.route,
                      title: "Route Management",
                      color: Colors.blue),
                ),

                /// STOP
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.stopScreen);
                  },
                  child: _gridCard(
                      icon: Icons.location_on,
                      title: "Stop Management",
                      color: Colors.orange),
                ),

                /// TRANSPORT FEE
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, RoutesName.transportFeeScreen);
                  },
                  child: _gridCard(
                      icon: Icons.directions_bus,
                      title: "Assign Transport",
                      color: Colors.green),
                ),

                /// STUDENT TRANSPORT FEE
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pushNamed(
                //         context,
                //         RoutesName.studentTransportFeeScreen);
                //   },
                //   child: _gridCard(
                //       icon: Icons.person,
                //       title: "Student Transport Fee",
                //       color: Colors.purple),
                // ),

              ],
            ),
          )
        ],
      ),
    );
  }

  /// GRID CARD WIDGET
  Widget _gridCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),

          const SizedBox(height: 10),

          AppText.customText(
            title,
            weight: FontWeight.bold,
            size: 12,
          ),
        ],
      ),
    );
  }
}