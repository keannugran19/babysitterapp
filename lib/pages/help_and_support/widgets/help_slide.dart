// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:babysitterapp/styles/colors.dart';
//
// class HelpSlide extends StatelessWidget {
//   final String svgAsset;
//   final String title;
//   final String description;
//   final Widget? button;
//
//   const HelpSlide({
//     super.key,
//     required this.svgAsset,
//     required this.title,
//     required this.description,
//     this.button,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SvgPicture.asset(
//           svgAsset,
//           height: 250,
//           width: 250,
//         ),
//         const SizedBox(height: 20),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: primaryColor,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 20),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 25),
//           child: Text(
//             description,
//             style: const TextStyle(fontSize: 16),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         const SizedBox(height: 30),
//         if (button != null) button!,
//       ],
//     );
//   }
// }
