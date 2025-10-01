import 'package:doc_authentificator/cubits/activities/activities_cubit.dart';
import 'package:doc_authentificator/cubits/activities/activities_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../models/activites_logs.dart';
import '../../../../utils/shared_preferences_utils.dart';
import '../../../../widgets/app_bar_drawer_widget.dart';
import '../../../../widgets/appbar_dashboard.dart';
import '../../../../widgets/new_drawer_dashboard.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    Future.delayed(Duration.zero, () {
      context.read<ActivitiesCubit>().getAllActivities(1);
    });
  }

  void _checkAuthentication() async {
    final token = SharedPreferencesUtils.getString('auth_token');
    if (token == null || token.isEmpty) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 1150;
    final isMobile = screenWidth < 600;

    return BlocBuilder<ActivitiesCubit, ActivitiesState>(
      builder: (context, state) {




        return Scaffold(
          drawer: isLargeScreen ? null : const NewDrawerDashboard(),
          body: Row(
            children: [
              if (isLargeScreen) const NewDrawerDashboard(),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: isLargeScreen
                          ? const AppBarDrawerWidget()
                          : AppBarVendorWidget(),
                    ),
                    if (state.listActivities == ActivitiesSatus.loading)
                      Center(child: CircularProgressIndicator(color: Colors.blueAccent,strokeWidth: 1,)),
                    if (state.activitiesSatus == ActivitiesSatus.error)
                      Center(child: Text("Aucune activité trouvée", style: Theme.of(context).textTheme.labelSmall)),

                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Column(
                            children: [
                              Expanded(
                                child: ActivitiesList(activities: state.listActivities!),
                              ),
                              const SizedBox(height: 12),
                              PaginationControls(
                                currentPage: state.currentPage,
                                lastPage: state.lastPage,
                                onPrevious: () => context.read<ActivitiesCubit>().goToPreviousPage(),
                                onNext: () => context.read<ActivitiesCubit>().goToNextPage(),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int lastPage;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.lastPage,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: currentPage > 1 ? onPrevious : null,
          icon: const Icon(Icons.arrow_back),
          label: const Text("Précédent"),
        ),
        const SizedBox(width: 16),
        Text("Page $currentPage / $lastPage"),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: currentPage < lastPage ? onNext : null,
          icon: const Icon(Icons.arrow_forward),
          label: const Text("Suivant"),
        ),
      ],
    );
  }
}

class ActivitiesList extends StatelessWidget {
  final List<ActivitesLogs> activities;

  const ActivitiesList({required this.activities, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: activities.length,
      separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300, height: 1),
      itemBuilder: (context, index) {
        final doc = activities[index];
        final isSuccess = doc.status == 'success';

        return ListTile(
          leading: Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: isSuccess ? Colors.green : Colors.red,
            size: 28,
          ),
          title: Text(
            doc.identifier,
            style:  Theme.of(context).textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          subtitle: Text("${doc.firstname} ${doc.lastname} •",style: Theme.of(context).textTheme.labelSmall,
              // " ${doc.createdAt.substring(0, 10)}"
              ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: isSuccess ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isSuccess ? "Succès" : "Échec",
              style: TextStyle(
                color: isSuccess ? Colors.green.shade800 : Colors.red.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () {
            // Optionnel: Afficher plus de détails
          },
        );
      },
    );
  }
}


