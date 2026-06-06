import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';

class AdvancedTopicsCard extends StatelessWidget {
  const AdvancedTopicsCard({super.key});

  @override
  Widget build(BuildContext context) {
    const topics = [
      _AdvancedTopic(
        icon: Icons.account_tree_outlined,
        title: 'Multiple API clients',
        body: 'Central factory creates isolated Dio instances per backend.',
      ),
      _AdvancedTopic(
        icon: Icons.key_outlined,
        title: 'Separate access tokens',
        body:
            'App token and products token are attached by different interceptors.',
      ),
      _AdvancedTopic(
        icon: Icons.timer_outlined,
        title: 'Different timeout policies',
        body:
            'Fast profile calls and slower product calls use separate timeout values.',
      ),
      _AdvancedTopic(
        icon: Icons.refresh_outlined,
        title: 'Single-flight refresh retry',
        body:
            'Only one token refresh runs when a 401 happens, then the request retries.',
      ),
      _AdvancedTopic(
        icon: Icons.report_problem_outlined,
        title: 'Manual 401 test button',
        body:
            'Force 401 retry expires the products token, then proves refresh and retry work.',
      ),
      _AdvancedTopic(
        icon: Icons.receipt_long_outlined,
        title: 'Request and response logs',
        body:
            'Every client logs requests, responses, errors, and retry calls with redacted auth headers.',
      ),
      _AdvancedTopic(
        icon: Icons.cached_outlined,
        title: 'Repository cache fallback',
        body:
            'Load from cache uses saved products and skips the products API when cache exists.',
      ),
      _AdvancedTopic(
        icon: Icons.health_and_safety_outlined,
        title: 'Safe failure mapping',
        body:
            'Dio exceptions become predictable Failure objects for UI/domain layers.',
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced coverage',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            const Text(
              'This demo is not just making a request. It shows the network decisions a production Flutter app usually needs.',
              style: TextStyle(
                color: AppTheme.muted,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            for (final topic in topics) _TopicRow(topic: topic),
          ],
        ),
      ),
    );
  }
}

class _AdvancedTopic {
  const _AdvancedTopic({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

class _TopicRow extends StatelessWidget {
  const _TopicRow({required this.topic});

  final _AdvancedTopic topic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
            child: Icon(topic.icon, color: AppTheme.primaryBlue, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.title,
                  style: const TextStyle(
                    color: AppTheme.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  topic.body,
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontSize: 12,
                    height: 1.35,
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
