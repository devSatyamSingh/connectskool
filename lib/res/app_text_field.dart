// import 'package:flutter/material.dart';
//
// class AppTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String? hint;
//   final TextInputType keyboardType;
//   final int maxLines;
//   final bool readOnly;
//   final Widget? prefix;
//   final Widget? suffix;
//   final String? errorText;
//
//   const AppTextField({
//     super.key,
//     required this.controller,
//     required this.label,
//     this.hint,
//     this.keyboardType = TextInputType.text,
//     this.maxLines = 1,
//     this.readOnly = false,
//     this.prefix,
//     this.suffix,
//     this.errorText,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: TextField(
//             controller: controller,
//             keyboardType: keyboardType,
//             maxLines: maxLines,
//             readOnly: readOnly,
//             cursorColor: Colors.blueAccent,
//             decoration: InputDecoration(
//               constraints: BoxConstraints(
//                 maxHeight: 50
//               ),
//               hintText: hint,
//               prefixIcon: prefix != null ? prefix : null,
//               suffixIcon: suffix != null ? suffix : null,
//               filled: true,
//               fillColor: Colors.white,
//               errorText: errorText,
//               contentPadding: const EdgeInsets.symmetric(
//                   vertical: 10, horizontal: 20),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 borderSide: BorderSide.none,
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType keyboardType;
  final bool readOnly;
  final Widget? prefix;
  final Widget? suffix;
  final String? errorText;
  final int minLines;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.prefix,
    this.suffix,
    this.errorText,
    this.minLines = 1, // start height
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontFamily: 'poppins'
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,

            minLines: minLines,   // 👈 starting height
            maxLines: null,       // 👈 auto grow unlimited

            cursorColor: Colors.blueAccent,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefix,
              suffixIcon: suffix,
              filled: true,
              fillColor: Colors.white,
              errorText: errorText,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Colors.blueAccent,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
