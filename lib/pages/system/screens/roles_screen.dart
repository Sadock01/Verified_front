// import 'package:flutter/material.dart';
//
// import '../../../../widgets/app_bar_widget.dart';
// import '../../../../widgets/app_bar_vendor_widget.dart';
// import '../../../../widgets/card_list_widget.dart';
// import '../../../../widgets/custom_search_widget.dart';
// import '../../../../widgets/drawer_widget.dart';
// import '../widgets/roles_widget.dart';
//
// class RolesPermissionsScreen extends StatelessWidget {
//   const RolesPermissionsScreen({super.key});
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
//                   Text('Platform Administration / Roles and Permissions',
//                       style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold)),
//                 ]),
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(children: [
//                     const SizedBox(height: 30),
//                     SizedBox(
//                       height: 420,
//                       child: CardListWidget(
//                         buttons: const [CustomSearchWidget()],
//                         actions: const [],
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: ConstrainedBox(
//                             constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
//                             child: const RolesPermissionsWidget(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ]),
//                 ),
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
