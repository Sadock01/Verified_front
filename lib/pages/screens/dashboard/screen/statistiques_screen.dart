import 'package:doc_authentificator/pages/screens/dashboard/widgets/pie_chart_widget.dart';
import 'package:doc_authentificator/pages/screens/dashboard/widgets/sales_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../const/const.dart';
import '../../../../cubits/collaborateurs/collaborateurs_cubit.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/shared_preferences_utils.dart';
import '../../../../widgets/app_bar_drawer_widget.dart';
import '../../../../widgets/appbar_dashboard.dart';
import '../../../../widgets/drawer_dashboard.dart';
import '../../../../widgets/new_drawer_dashboard.dart';
import '../widgets/stat_card_widget.dart';

class StatistiquesScreen extends StatefulWidget {
  const StatistiquesScreen({super.key});

  @override
  State<StatistiquesScreen> createState() => _StatistiquesScreenState();
}

class _StatistiquesScreenState extends State<StatistiquesScreen> {
  late Future<Map<String, dynamic>> _statsFuture;

  // @override
  // void initState() {
  //   super.initState();
  //
  // }

  @override
  void initState() {
    super.initState();
    _statsFuture = fetchStats();
    _checkAuthentication();
    context.read<CollaborateursCubit>().getCustomerDetails();
  }

  void _checkAuthentication() async {
    final token = SharedPreferencesUtils.getString('auth_token');
    if (token == null || token.isEmpty) {
      // Rediriger vers la page de login
      context.go('/login'); // ou Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<Map<String, dynamic>> fetchStats() async {
    await Future.delayed(Duration(seconds: 1)); // Simule un delay API
    return {
      'total_collaborateurs': 128,
      'total_documents': 342,
      'total_verifications': 876,
      'total_types_documents': 15,
      'graph_data': [
        {'label': 'Authentiques', 'value': 600},
        {'label': 'Non Authentiques', 'value': 200},
        {'label': 'En Attente', 'value': 76},
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 4;
    if (screenWidth < 1200) crossAxisCount = 2;
    if (screenWidth < 700) crossAxisCount = 1;
    final isLargeScreen = MediaQuery.of(context).size.width > 1150;
    // final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      drawer: isLargeScreen ? null : const NewDrawerDashboard(),
      body: SafeArea(
        child: Row(
          children: [
            if (isLargeScreen) const NewDrawerDashboard(),
            Expanded(
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double width = constraints.maxWidth;
                      if (isLargeScreen) {
                        return SizedBox(height: 60, child: AppBarDrawerWidget());
                      } else {
                        return AppBarVendorWidget();
                      }
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: _statsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Erreur : ${snapshot.error}"));
                          } else {
                            final data = snapshot.data!;
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tableau de bord des statistiques",
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: StatCardWidget(
                                            title: "Total Documents",
                                            value: "30",
                                            subtitle: "+150 last month",
                                            percentage: "+13.9%",
                                            isPositive: true,
                                            color: Colors.orangeAccent,
                                            imageUrl: "assets/images/documentation.png"),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: StatCardWidget(
                                          title: "Total Verifications",
                                          value: "100",
                                          subtitle: "+500,000 last month",
                                          percentage: "+16.1%",
                                          isPositive: true,
                                          imageUrl: "assets/images/quality-assurance.png",
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: StatCardWidget(
                                          title: "Total Types",
                                          value: "10",
                                          subtitle: "+2.3% last month",
                                          percentage: "+11.1%",
                                          isPositive: true,
                                          imageUrl: "assets/images/file.png",
                                          color: Colors.blue,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: StatCardWidget(
                                          title: "Total Collaborateurs",
                                          value: "23",
                                          subtitle: "+2,984 last month",
                                          percentage: "-10.5%",
                                          isPositive: false,
                                          color: AppColors.PRIMARY_BLUE_COLOR,
                                          imageUrl: "assets/images/people.png",
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 32),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      double width = constraints.maxWidth;

                                      if (width > 1024) {
                                        return Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            /// Le graphique principal
                                            Expanded(
                                              flex: 2,
                                              child: SalesChartWidget(),
                                            ),
                                            SizedBox(width: 16),

                                            /// Le camembert
                                            Expanded(
                                              flex: 1,
                                              child: InventoryPieChart(inStock: 10, outOfStock: 40),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            SalesChartWidget(),
                                            SizedBox(height: 16),
                                            InventoryPieChart(inStock: 10, outOfStock: 40),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white, // <-- Fond blanc
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 28,
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontSize: 16, color: color.withValues(alpha: 0.9), overflow: TextOverflow.ellipsis)),
              const SizedBox(height: 6),
              Text(value, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 26, fontWeight: FontWeight.bold, color: color.darken())),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildBarChart(List<dynamic> data) {
  //   final maxY = data.map<int>((item) => item['value'] as int).reduce((a, b) => a > b ? a : b).toDouble() * 1.2;
  //
  //   List<BarChartGroupData> barGroups = [];
  //   for (int i = 0; i < data.length; i++) {
  //     final item = data[i];
  //     barGroups.add(
  //       BarChartGroupData(
  //         x: i,
  //         barRods: [
  //           BarChartRodData(
  //             toY: (item['value'] as int).toDouble(),
  //             color: _colorFromLabel(item['label']),
  //             width: 22,
  //             borderRadius: BorderRadius.circular(6),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   return BarChart(
  //     BarChartData(
  //       maxY: maxY,
  //       barGroups: barGroups,
  //       titlesData: FlTitlesData(
  //         bottomTitles: AxisTitles(
  //           sideTitles: SideTitles(
  //             showTitles: true,
  //             getTitlesWidget: (value, meta) {
  //               final index = value.toInt();
  //               if (index < 0 || index >= data.length) return const SizedBox();
  //               return SideTitleWidget(
  //                 meta: meta,
  //                 child: Text(data[index]['label']),
  //               );
  //             },
  //             reservedSize: 40,
  //           ),
  //         ),
  //         leftTitles: AxisTitles(
  //           sideTitles: SideTitles(showTitles: true, reservedSize: 40),
  //         ),
  //         topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //         rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //       ),
  //       gridData: FlGridData(show: true),
  //       borderData: FlBorderData(show: false),
  //     ),
  //   );
  // }

  Color _colorFromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'authentiques':
        return Colors.green;
      case 'non authentiques':
        return Colors.red;
      case 'en attente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

extension ColorBrightness on Color {
  Color darken([double amount = .2]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
