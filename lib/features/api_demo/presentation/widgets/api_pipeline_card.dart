import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';

class ApiPipelineCard extends StatelessWidget {
  const ApiPipelineCard({
    super.key,
    required this.isLoaded,
    required this.refreshCount,
  });

  final bool isLoaded;
  final int refreshCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Request pipeline',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 14),
            _PipelineStep(
              icon: Icons.person_search_outlined,
              title: 'Users API',
              subtitle: 'App token, short timeout profile',
              isComplete: isLoaded,
            ),
            const _StepConnector(),
            _PipelineStep(
              icon: Icons.vpn_key_outlined,
              title: 'Products API',
              subtitle: refreshCount == 0
                  ? 'Separate token, longer timeout profile'
                  : '401 handled, products token refreshed once',
              isComplete: refreshCount > 0,
              accentColor: AppTheme.warning,
            ),
            const _StepConnector(),
            _PipelineStep(
              icon: Icons.inventory_2_outlined,
              title: 'Repository + cache',
              subtitle: 'Remote data mapped into domain entities',
              isComplete: isLoaded,
              accentColor: AppTheme.success,
            ),
          ],
        ),
      ),
    );
  }
}

class _PipelineStep extends StatelessWidget {
  const _PipelineStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isComplete,
    this.accentColor = AppTheme.primaryBlue,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isComplete;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: isComplete
                ? accentColor.withValues(alpha: 0.12)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(
            isComplete ? Icons.check : icon,
            color: isComplete ? accentColor : AppTheme.muted,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(color: AppTheme.muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: SizedBox(
        height: 18,
        child: VerticalDivider(width: 1, thickness: 1, color: AppTheme.border),
      ),
    );
  }
}
