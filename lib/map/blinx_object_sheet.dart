// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'blinx_map_controller.dart';
//
// class BlinxObjectSheet extends StatelessWidget {
//   final BlinxObject object;
//   const BlinxObjectSheet({super.key, required this.object});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 margin: const EdgeInsets.only(top: 12, bottom: 8),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//
//             // Image
//             if (object.imageUrl != null && object.imageUrl!.isNotEmpty)
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(24),
//                 ),
//                 child: Image.network(
//                   object.imageUrl!,
//                   width: double.infinity,
//                   height: 180,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => _imagePlaceholder(),
//                 ),
//               )
//             else
//               _imagePlaceholder(),
//
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ── Name + Distance ──
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           object.name,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF2C2C2C),
//                           ),
//                         ),
//                       ),
//
//                       if (object.distanceLabel.isNotEmpty)
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF2A73EA).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             object.distanceLabel,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xFF2A73EA),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   Text(
//                     object.description.isNotEmpty
//                         ? object.description
//                         : "No description available",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                       height: 1.5,
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // ── CTA Button ──
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Get.back();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF2A73EA),
//                         foregroundColor: Colors.white,
//                         minimumSize: const Size(double.infinity, 50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: const Text(
//                         "View Details",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _imagePlaceholder() {
//     return Container(
//       width: double.infinity,
//       height: 160,
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF5F3EF),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: const Icon(
//         Icons.image_outlined,
//         size: 48,
//         color: Color(0xFFCCCCCC),
//       ),
//     );
//   }
// }
//
// //Helper
// void showBlinxObjectSheet(BuildContext context, BlinxObject object) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (_) => BlinxObjectSheet(object: object),
//   );
// }
