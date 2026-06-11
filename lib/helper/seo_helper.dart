// // import 'package:universal_html/html.dart' as html;
// //
// // class SeoHelper {
// //   static void updateSeoTags({
// //     required String title,
// //     required String description,
// //     required String image,
// //     required List<String> keywords,
// //     String? url,
// //   }) {
// //     // Set page title
// //     html.document.title = title;
// //
// //     // Remove old meta tags (to avoid duplicates)
// //     _removeMeta('description');
// //     _removeMeta('keywords');
// //     _removeMeta('og:title');
// //     _removeMeta('og:description');
// //     _removeMeta('og:image');
// //     _removeMeta('og:url');
// //
// //     // Add new meta tags
// //     _setMeta('description', description);
// //     _setMeta('keywords', keywords.join(', '));
// //     _setMeta('og:title', title);
// //     _setMeta('og:description', description);
// //     _setMeta('og:image', image);
// //     _setMeta('og:url', url ?? html.window.location.href);
// //   }
// //
// //   static void _removeMeta(String name) {
// //     final meta = html.document.head?.querySelector(
// //       'meta[name="$name"], meta[property="$name"]',
// //     );
// //     meta?.remove();
// //   }
// //
// //   static void _setMeta(String name, String content) {
// //     final meta = html.MetaElement()
// //       ..name = name
// //       ..content = content;
// //     html.document.head?.append(meta);
// //   }
// // }
// import 'package:universal_html/html.dart' as html;
//
// class SeoHelper {
//   static void updateSeoTags({
//     required String title,
//     required String description,
//     required String image,
//     required List<String> keywords,
//     String? url,
//   }) {
//     // Set page title
//     html.document.title = title;
//
//     // Remove old meta tags (to avoid duplicates)
//     _removeMeta('description');
//     _removeMeta('keywords');
//     _removeMeta('og:title');
//     _removeMeta('og:description');
//     _removeMeta('og:image');
//     _removeMeta('og:url');
//     _removeMeta('google-site-verification'); // ✅ remove old verification tag if exists
//
//     // Add new meta tags
//     _setMeta('description', description);
//     _setMeta('keywords', keywords.join(', '));
//     _setMeta('og:title', title);
//     _setMeta('og:description', description);
//     _setMeta('og:image', image);
//     _setMeta('og:url', url ?? html.window.location.href);
//
//     // ✅ Add Google verification meta tag
//     _setMeta(
//       'google-site-verification',
//       'g_n6vJ7TCLWV3A181dk6eZEOgkap58B9M8KRA20Bb4Q',
//     );
//   }
//
//   static void _removeMeta(String name) {
//     final meta = html.document.head?.querySelector(
//       'meta[name="$name"], meta[property="$name"]',
//     );
//     meta?.remove();
//   }
//
//   static void _setMeta(String name, String content) {
//     final meta = html.MetaElement()
//       ..name = name
//       ..content = content;
//     html.document.head?.append(meta);
//   }
// }
