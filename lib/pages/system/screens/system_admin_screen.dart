import 'package:doc_authentificator/widgets/new_drawer_dashboard.dart';
import 'package:flutter/material.dart';

import '../../../widgets/app_bar_drawer_widget.dart';
import '../../../widgets/appbar_dashboard.dart';
import '../widgets/system_admin_widget.dart';

class SystemAdminScreen extends StatelessWidget {
  const SystemAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      drawer: isLargeScreen ? null : const NewDrawerDashboard(),
      body: SafeArea(
        child: Row(children: [
          if (isLargeScreen) const NewDrawerDashboard(),
          Expanded(
            child: Column(children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  double width = constraints.maxWidth;
                  if (width > 900) {
                    return const SizedBox(height: 60, child: AppBarDrawerWidget());
                  } else {
                    return const AppBarVendorWidget();
                  }
                },
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(children: [
                  Text('Dashboard/ ', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.blue)),
                  Text('System', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold)),
                ]),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('System', style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const Expanded(child: SystemAdminWidget()),
                  ]),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
