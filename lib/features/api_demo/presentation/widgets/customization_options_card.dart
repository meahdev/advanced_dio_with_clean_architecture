import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';

class CustomizationOptionsCard extends StatelessWidget {
  const CustomizationOptionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    const options = [
      _CustomizationOption(
        icon: Icons.link_outlined,
        title: 'Base URL per API',
        detail: 'Users and products clients can point to different domains.',
      ),
      _CustomizationOption(
        icon: Icons.timer_outlined,
        title: 'Timeout profile',
        detail: 'Configure connect, receive, and send timeout per Dio client.',
      ),
      _CustomizationOption(
        icon: Icons.http_outlined,
        title: 'Default headers',
        detail: 'Attach API-specific headers before requests leave the app.',
      ),
      _CustomizationOption(
        icon: Icons.security_outlined,
        title: 'Token strategy',
        detail: 'Use different token stores and interceptors for each API.',
      ),
      _CustomizationOption(
        icon: Icons.refresh_outlined,
        title: 'Retry client',
        detail:
            'Replay failed requests with a fresh token using plain retry Dio.',
      ),
      _CustomizationOption(
        icon: Icons.receipt_long_outlined,
        title: 'Logging',
        detail:
            'Log request, response, error, query, body, and redacted headers.',
      ),
      _CustomizationOption(
        icon: Icons.storage_outlined,
        title: 'Cache policy',
        detail: 'Remote fetch writes cache; cache load avoids products API.',
      ),
      _CustomizationOption(
        icon: Icons.warning_amber_outlined,
        title: 'Failure mapping',
        detail: 'Convert timeout, 401, client, and server errors into Failure.',
      ),
      _CustomizationOption(
        icon: Icons.cable_outlined,
        title: 'Custom adapter',
        detail: 'Swap real HTTP with fake adapters for tests or demos.',
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customization options',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            const Text(
              'These are the advanced Dio knobs exposed by this setup.',
              style: TextStyle(
                color: AppTheme.muted,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth > 520 ? 2 : 1;
                return GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: columns == 2 ? 2.9 : 3.5,
                  children: [
                    for (final option in options)
                      _CustomizationTile(option: option),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomizationOption {
  const _CustomizationOption({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;
}

class _CustomizationTile extends StatelessWidget {
  const _CustomizationTile({required this.option});

  final _CustomizationOption option;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFE9F3FF),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(option.icon, color: AppTheme.primaryBlue, size: 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.ink,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  option.detail,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontSize: 11.5,
                    height: 1.25,
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
