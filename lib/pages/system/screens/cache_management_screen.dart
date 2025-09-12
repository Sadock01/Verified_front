// import 'package:flutter/material.dart';
//
// import '../../../../widgets/app_bar_widget.dart';
// import '../../../../widgets/app_bar_vendor_widget.dart';
// import '../../../../widgets/drawer_widget.dart';
// import '../widgets/cache_management_widget.dart';
//
// class CacheManagementScreen extends StatelessWidget {
//   const CacheManagementScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final isLargeScreen = MediaQuery.of(context).size.width > 1150;
//     return Scaffold(
//       drawer: isLargeScreen ? null : const DrawerDashboard(),
//       body: SafeArea(
//         child: Row(children: [
//           if (isLargeScreen) const DrawerDashboard(),
//           Expanded(
//             child: Column(children: [
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   double width = constraints.maxWidth;
//                   if (width > 1150) {
//                     return const SizedBox(height: 60, child: AppbarDashboard());
//                   } else {
//                     return const AppBarVendorWidget();
//                   }
//                 },
//               ),
//               const SizedBox(height: 12),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                 child: Row(children: [
//                   Text('Dashboard/ ', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.blue)),
//                   Text('Platform Administration / Cache Management',
//                       style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold)),
//                 ]),
//               ),
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                 child: const CacheManagementWidget(),
//               ),
//             ]),
//           ),
//         ]),
//       ),
//     );
//   }
// }
//
//
