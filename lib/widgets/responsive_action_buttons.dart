import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResponsiveActionButtons extends StatelessWidget {
  final VoidCallback? onReload;
  final String? newDocumentRoute;
  final String? reloadText;
  final String? newDocumentText;

  const ResponsiveActionButtons({
    Key? key,
    this.onReload,
    this.newDocumentRoute,
    this.reloadText = "Reload",
    this.newDocumentText = "Nouveau document",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        
        if (isSmallScreen) {
          // Layout vertical pour petits écrans
          return Column(
            children: [
              _buildNewDocumentButton(context),
              const SizedBox(height: 8),
              _buildReloadButton(context),
            ],
          );
        } else {
          // Layout horizontal pour grands écrans
          return Row(
            children: [
              _buildNewDocumentButton(context),
              const SizedBox(width: 10),
              _buildReloadButton(context),
            ],
          );
        }
      },
    );
  }

  Widget _buildNewDocumentButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (newDocumentRoute != null) {
          context.go(newDocumentRoute!);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                newDocumentText!,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReloadButton(BuildContext context) {
    return InkWell(
      onTap: onReload,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/reload.png',
              width: 18,
              height: 18,
              color: Colors.grey[300],
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                reloadText!,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
