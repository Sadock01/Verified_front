import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SystemAdminWidget extends StatelessWidget {
  const SystemAdminWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = <_SysTileData>[
      _SysTileData(
        'Users',
        'View and update your system users',
        Icons.people_outline,
        onTap: () => context.go('/system/users'),
      ),
      _SysTileData(
        'Roles And Permissions',
        'View and update your roles and permissions',
        Icons.verified_user_outlined,
        onTap: () => context.go('/system/roles'),
      ),
      _SysTileData(
        'Request Logs',
        'View and delete your system request logs',
        Icons.receipt_long_outlined,
        onTap: () => context.go('/system/request-logs'),
      ),
      _SysTileData(
        'Activities Logs',
        'View and delete your system activity logs',
        Icons.event_note_outlined,
        onTap: () => context.go('/system/activities-logs'),
      ),
      _SysTileData('Backup', 'Backup database and uploads folder.', Icons.backup_outlined),
      _SysTileData('Cronjob', 'Automate certain commands or scripts on your site.', Icons.schedule_outlined),
      _SysTileData('Security Settings', 'Manage cookie security and HTTP headers', Icons.shield_outlined),

      _SysTileData(
        'Cache Management',
        'Clear cache to make your site up to date.',
        Icons.cached_outlined,
        onTap: () => context.go('/system/cache-management'),
      ),
      _SysTileData('Cleanup System', 'Cleanup your unused data in database', Icons.cleaning_services_outlined),
      _SysTileData('System Information', 'All information about current system configuration.', Icons.info_outline),
      _SysTileData('System Updater', 'Update your system to the latest version', Icons.system_update_alt_outlined),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double gap = 12;
        final int columns = maxWidth >= 1500
            ? 4
            : maxWidth >= 1150
                ? 3
                : maxWidth >= 750
                    ? 2
                    : 1;
        final double tileWidth = (maxWidth - gap * (columns - 1)) / columns;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final t in tiles) SizedBox(width: tileWidth, child: _SysTile(data: t)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SysTileData {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  const _SysTileData(this.title, this.subtitle, this.icon, {this.onTap});
}

class _SysTile extends StatelessWidget {
  final _SysTileData data;
  const _SysTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: Theme.of(context).brightness == Brightness.light
              ? [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(data.icon, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(data.title, style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(data.subtitle, style: Theme.of(context).textTheme.displaySmall),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}


