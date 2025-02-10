import 'package:doc_authentificator/pages/screens/widgets/bipartite_chart_widget.dart';
import 'package:doc_authentificator/pages/screens/widgets/stats_card_widget.dart';
import 'package:doc_authentificator/repositories/utils_repository.dart';
import 'package:doc_authentificator/widgets/appbar_dashboard.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';

import 'package:flutter/material.dart';

class StatistiquesScreen extends StatefulWidget {
  const StatistiquesScreen({super.key});

  @override
  State<StatistiquesScreen> createState() => _StatistiquesScreenState();
}

class _StatistiquesScreenState extends State<StatistiquesScreen> {
  final UtilsRepository _utilsRepository = UtilsRepository();
  late Future<Map<String, dynamic>> _statsFuture;
  late Future<List<Map<String, dynamic>>> _graphStatsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = fetchStats();
    _graphStatsFuture = _utilsRepository.statistiquesByVerificationStatus();
  }

  /// Récupère les statistiques générales
  Future<Map<String, dynamic>> fetchStats() async {
    try {
      final totalVerifications = await _utilsRepository.totalVerifications();
      final totalDocuments = await _utilsRepository.totalDocuments();
      return {
        'total_verifications': totalVerifications['total_verifications'],
        'total_documents': totalDocuments['total_documents'],
      };
    } catch (e) {
      return Future.error("Erreur lors du chargement des statistiques");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          DrawerDashboard(),
          Expanded(
            child: Column(
              children: [
                AppbarDashboard(),
                Flexible(
                  flex: 8,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Affichage des cartes de statistiques
                        FutureBuilder<Map<String, dynamic>>(
                          future: _statsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: LinearProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text(snapshot.error.toString()));
                            } else {
                              final stats = snapshot.data!;
                              return Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                children: [
                                  StatsCardWidget(
                                    title: "Total Vérifications",
                                    value: stats['total_verifications'].toString(),
                                    color: Colors.green,
                                  ),
                                  StatsCardWidget(
                                    title: "Total Documents",
                                    value: stats['total_documents'].toString(),
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ],
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 30),

                        /// Affichage du graphique
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _graphStatsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: LinearProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text(snapshot.error.toString()));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text("Aucune donnée disponible pour le graphe"));
                            }

                            return BipartiteChartWidget(verificationStats: snapshot.data!);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
