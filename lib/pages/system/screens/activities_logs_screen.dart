// import 'package:doc_authentificator/widgets/new_drawer_dashboard.dart';
// import 'package:flutter/material.dart';
//
// import '../../../widgets/app_bar_drawer_widget.dart';
// import '../widgets/activities_logs_list_widget.dart';
//
// class ActivitiesLogsScreen extends StatelessWidget {
//   const ActivitiesLogsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final isLargeScreen = MediaQuery.of(context).size.width > 1150;
//     return Scaffold(
//       drawer: isLargeScreen ? null : const NewDrawerDashboard(),
//       body: SafeArea(
//         child: Row(children: [
//           // if (isLargeScreen) const DrawerDashboard(),
//           Expanded(
//             child: Column(children: [
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   double width = constraints.maxWidth;
//                   if (width > 1150) {
//                     return const SizedBox(height: 60, child: AppBarDrawerWidget());
//                   } else {
//                     return const SizedBox();
//                   }
//                 },
//               ),
//               const SizedBox(height: 12),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                 child: Row(children: [
//                   Text('Dashboard/ ', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.blue)),
//                   Text('Platform Administration / Activities Logs',
//                       style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold)),
//                 ]),
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(children: [
//                     const SizedBox(height: 30),
//                     SizedBox(
//                       height: 520,
//                       child: CardListWidget(
//                         buttons: const [CustomSearchWidget()],
//                         actions: [
//                           Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Theme.of(context).dividerColor),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Row(children: [
//                               const Icon(Icons.delete_forever, size: 18),
//                               const SizedBox(width: 10),
//                               Text('Delete all records', style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold)),
//                             ]),
//                           ),
//                           const SizedBox(width: 10),
//                           Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Theme.of(context).dividerColor),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Row(children: [
//                               const Icon(Icons.refresh, size: 18),
//                               const SizedBox(width: 10),
//                               Text('Reload', style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold)),
//                             ]),
//                           ),
//                         ],
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: ConstrainedBox(
//                             constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
//                             child: const ActivitiesLogsListWidget(),
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
