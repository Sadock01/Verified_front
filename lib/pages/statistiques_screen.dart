import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../const/const.dart';
import '../widgets/appbar_dashboard.dart';
import '../widgets/drawer_dashboard.dart';

class StatistiquesScreen extends StatefulWidget {
  const StatistiquesScreen({super.key});

  @override
  State<StatistiquesScreen> createState() => _StatistiquesScreenState();
}

class _StatistiquesScreenState extends State<StatistiquesScreen> {
  late Future<Map<String, dynamic>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = fetchStats();
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

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Row(
          children: [
            DrawerDashboard(),
            Expanded(
              child: Column(
                children: [
                  AppbarDashboard(),
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
                            return Column(
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

                                // Grille des stats
                                Flexible(
                                  flex: 3,
                                  child: GridView.count(
                                    physics: const NeverScrollableScrollPhysics(),
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 2.8,
                                    children: [
                                      _buildStatCard(
                                        title: "Collaborateurs",
                                        value: data['total_collaborateurs'].toString(),
                                        icon: Icons.group,
                                        color: Colors.deepPurple,
                                      ),
                                      _buildStatCard(
                                        title: "Documents",
                                        value: data['total_documents'].toString(),
                                        icon: Icons.description,
                                        color: Colors.blue,
                                      ),
                                      _buildStatCard(
                                        title: "Vérifications",
                                        value: data['total_verifications'].toString(),
                                        icon: Icons.verified,
                                        color: Colors.green,
                                      ),
                                      _buildStatCard(
                                        title: "Types de Documents",
                                        value: data['total_types_documents'].toString(),
                                        icon: Icons.folder,
                                        color: Colors.orange,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // Histogramme
                                // Flexible(
                                //   flex: 5,
                                //   child: Card(
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(16),
                                //     ),
                                //     elevation: 5,
                                //     child: Padding(
                                //       padding: const EdgeInsets.all(20.0),
                                //       child: Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           Text(
                                //             "Répartition des vérifications",
                                //             style: theme.textTheme.labelMedium?.copyWith(
                                //               fontWeight: FontWeight.bold,
                                //             ),
                                //           ),
                                //           const SizedBox(height: 24),
                                //
                                //           // Expanded(
                                //           //   child: _buildBarChart(data['graph_data']),
                                //           // ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
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
        color: Colors.white,  // <-- Fond blanc
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
              Text(title, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16, color: color.withValues(alpha: 0.9),overflow: TextOverflow.ellipsis)),
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
