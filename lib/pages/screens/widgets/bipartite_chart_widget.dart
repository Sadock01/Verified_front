import 'package:doc_authentificator/const/const.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BipartiteChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> verificationStats;

  const BipartiteChartWidget({super.key, required this.verificationStats});

  /// Génère les données pour les barres du graphique en fonction des dates
  List<BarChartGroupData> _generateBarGroups() {
    final groupedStats = <String, int>{};
    
    for (var stat in verificationStats) {
      final date = stat['date']; // Supposons que la date est au format 'YYYY-MM-DD'
      final count = (stat['count'] as num).toInt();
      
      if (groupedStats.containsKey(date)) {
        groupedStats[date] = groupedStats[date]! + count;
      } else {
        groupedStats[date] = count;
      }
    }

    return groupedStats.entries.map((entry) {
      return BarChartGroupData(
        x: groupedStats.keys.toList().indexOf(entry.key),
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blue, // Choisis une couleur qui te convient
            width: 16,
          ),
        ],
      );
    }).toList();
  }

  /// Détermine la valeur maximale de l'axe Y
  double _getMaxY() {
    final allCounts = verificationStats
        .map((stat) => (stat['count'] as num).toDouble())
        .toList();
    if (allCounts.isEmpty) return 10;
    return (allCounts.reduce((a, b) => a > b ? a : b) * 1.2).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: Const.screenHeight(context),
        height: Const.screenHeight(context)*0.5,
        child: BarChart(
          BarChartData(
            maxY: _getMaxY(),
            barGroups: _generateBarGroups(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(value.toInt().toString());
                  },
                  reservedSize: 32,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < verificationStats.length) {
                      final date = verificationStats[index]['date'];
                      return Text(date); // Afficher la date sur l'axe des abscisses
                    }
                    return const Text("");
                  },
                  reservedSize: 32,
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            gridData: FlGridData(show: true),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (groupIndex, rodIndex, rodData, barChartData) {
                  return BarTooltipItem(
                    rodData.toY.toString(),
                    TextStyle(color: Colors.white), // Ajuste la couleur du texte ici
                    
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
