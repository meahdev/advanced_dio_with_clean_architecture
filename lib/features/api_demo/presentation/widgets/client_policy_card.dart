import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../core/network/api_base.dart';
import '../../../../core/network/api_client_factory.dart';

class ClientPolicyCard extends StatelessWidget {
  const ClientPolicyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client policies',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            const Text(
              'Each API gets its own Dio instance, token strategy, interceptor, and timeout profile.',
              style: TextStyle(
                color: AppTheme.muted,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            _PolicyRow(
              icon: Icons.person_outline,
              title: 'Users API',
              baseUrl: ApiBase.usersApi,
              token: 'appToken',
              interceptor: 'AppApiInterceptor',
              timeout:
                  '${ApiClientFactory.usersConnectTimeout.inSeconds}s connect / ${ApiClientFactory.usersReceiveTimeout.inSeconds}s receive',
              logger: 'USERS_API',
              color: AppTheme.primaryBlue,
            ),
            const SizedBox(height: 10),
            _PolicyRow(
              icon: Icons.inventory_2_outlined,
              title: 'Products API',
              baseUrl: ApiBase.productsApi,
              token: 'productsToken',
              interceptor: 'ProductsApiInterceptor',
              timeout:
                  '${ApiClientFactory.productsConnectTimeout.inSeconds}s connect / ${ApiClientFactory.productsReceiveTimeout.inSeconds}s receive',
              logger: 'PRODUCTS_API + RETRY',
              color: AppTheme.warning,
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyRow extends StatelessWidget {
  const _PolicyRow({
    required this.icon,
    required this.title,
    required this.baseUrl,
    required this.token,
    required this.interceptor,
    required this.timeout,
    required this.logger,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String baseUrl;
  final String token;
  final String interceptor;
  final String timeout;
  final String logger;
  final Color color;

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
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, color: color, size: 18),
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
                const SizedBox(height: 8),
                _PolicyLine(label: 'Base URL', value: baseUrl),
                _PolicyLine(label: 'Token', value: token),
                _PolicyLine(label: 'Interceptor', value: interceptor),
                _PolicyLine(label: 'Timeout', value: timeout),
                _PolicyLine(label: 'Logger', value: logger),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyLine extends StatelessWidget {
  const _PolicyLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(label, style: Theme.of(context).textTheme.labelMedium),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
