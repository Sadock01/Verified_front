import 'package:flutter/material.dart';

class CacheManagementWidget extends StatelessWidget {
  const CacheManagementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = <_CacheRowData>[
      _CacheRowData(
        icon: Icons.save_alt,
        title: 'Clear all CMS cache',
        description: 'Clear CMS caching: database caching, static blocks... Run this command when you don\'t see the changes after updating data.',
        actionLabel: 'Clear',
        actionColor: Colors.blue,
        trailingPill: 'Current Size: 44,90 MB',
      ),
      _CacheRowData(icon: Icons.auto_fix_high, title: 'Refresh compiled views', description: 'Clear compiled views to make views up to date.', actionLabel: 'Refresh', actionColor: Colors.orange),
      _CacheRowData(icon: Icons.settings_backup_restore, title: 'Clear config cache', description: 'You might need to refresh the config caching when you change something on production environment.', actionLabel: 'Clear', actionColor: Colors.blue),
      _CacheRowData(icon: Icons.alt_route, title: 'Clear route cache', description: 'Clear cache routing.', actionLabel: 'Clear', actionColor: Colors.green),
      _CacheRowData(icon: Icons.delete_sweep, title: 'Clear log', description: 'Clear system log files', actionLabel: 'Clear', actionColor: Colors.red),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: theme.brightness == Brightness.light
            ? [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 10, spreadRadius: 10, offset: const Offset(0, 3))]
            : [],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.cached),
          const SizedBox(width: 8),
          Text('Cache Management', style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 12),
        Text('Clear cache to make your site up to date.', style: theme.textTheme.displaySmall),
        const SizedBox(height: 12),
        Divider(color: theme.dividerColor),
        const SizedBox(height: 12),
        ...rows.map((r) => _CacheRow(data: r)),
        const SizedBox(height: 16),
        Row(children: [
          const Icon(Icons.info_outline, size: 16),
          const SizedBox(width: 6),
          Expanded(child: Text('Clear cache after making changes to your site to ensure they appear correctly.', style: theme.textTheme.displaySmall)),
        ]),
      ]),
    );
  }
}

class _CacheRowData {
  final IconData icon;
  final String title;
  final String description;
  final String actionLabel;
  final Color actionColor;
  final String? trailingPill;
  _CacheRowData({required this.icon, required this.title, required this.description, required this.actionLabel, required this.actionColor, this.trailingPill});
}

class _CacheRow extends StatelessWidget {
  final _CacheRowData data;
  const _CacheRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 32, child: Icon(data.icon, color: theme.colorScheme.primary)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(data.title, style: theme.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600))),
              if (data.trailingPill != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
                  child: Text(data.trailingPill!, style: theme.textTheme.labelSmall!.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                ),
              const SizedBox(width: 12),
              _actionBtn(context, data.actionLabel, data.actionColor),
            ]),
            const SizedBox(height: 6),
            Text(data.description, style: theme.textTheme.displaySmall),
          ]),
        ),
      ]),
      const SizedBox(height: 16),
      Divider(color: theme.dividerColor),
      const SizedBox(height: 16),
    ]);
  }

  Widget _actionBtn(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}


