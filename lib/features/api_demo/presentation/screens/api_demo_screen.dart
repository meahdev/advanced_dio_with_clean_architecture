import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_theme.dart';
import '../../../../core/error/failure.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../bloc/api_demo_bloc.dart';
import '../bloc/api_demo_event.dart';
import '../bloc/api_demo_state.dart';
import '../widgets/advanced_topics_card.dart';
import '../widgets/api_pipeline_card.dart';
import '../widgets/client_policy_card.dart';
import '../widgets/customization_options_card.dart';
import '../widgets/dashboard_toolbar.dart';
import '../widgets/metric_tile.dart';
import '../widgets/response_card.dart';

class ApiDemoScreen extends StatelessWidget {
  const ApiDemoScreen({super.key});

  Future<void> _dispatchAndWait(
    BuildContext context,
    ApiDemoEvent event,
  ) async {
    final bloc = context.read<ApiDemoBloc>()..add(event);
    await bloc.stream.firstWhere((state) => !state.isLoading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const DashboardToolbar(),
          Expanded(
            child: BlocBuilder<ApiDemoBloc, ApiDemoState>(
              builder: (context, state) {
                return RefreshIndicator.adaptive(
                  onRefresh: () => _dispatchAndWait(
                    context,
                    const ApiDemoCallApisRequested(),
                  ),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                    children: [
                      _HeroPanel(
                        isLoading: state.isLoading,
                        hasLoaded: state.hasLoaded,
                        onPressed: state.isLoading
                            ? null
                            : () => context.read<ApiDemoBloc>().add(
                                const ApiDemoCallApisRequested(),
                              ),
                        onForceRetry: state.isLoading
                            ? null
                            : () => context.read<ApiDemoBloc>().add(
                                const ApiDemoForce401RetryRequested(),
                              ),
                        onCachePressed: state.isLoading
                            ? null
                            : () => context.read<ApiDemoBloc>().add(
                                const ApiDemoLoadFromCacheRequested(),
                              ),
                      ),
                      const SizedBox(height: 14),
                      _MetricsGrid(
                        token: state.productsToken,
                        refreshCount: state.refreshCount,
                        productsCount: state.products.length,
                        hasProfile: state.profile != null,
                        productMode: state.productMode,
                      ),
                      if (state.failure != null) ...[
                        const SizedBox(height: 14),
                        _FailureBanner(failure: state.failure!),
                      ],
                      const SizedBox(height: 14),
                      ApiPipelineCard(
                        isLoaded: state.hasLoaded,
                        refreshCount: state.refreshCount,
                      ),
                      const SizedBox(height: 14),
                      const ClientPolicyCard(),
                      const SizedBox(height: 14),
                      const CustomizationOptionsCard(),
                      const SizedBox(height: 14),
                      const AdvancedTopicsCard(),
                      const SizedBox(height: 14),
                      _ProfileResponse(profile: state.profile),
                      const SizedBox(height: 14),
                      _ProductsResponse(products: state.products),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.isLoading,
    required this.hasLoaded,
    required this.onPressed,
    required this.onForceRetry,
    required this.onCachePressed,
  });

  final bool isLoading;
  final bool hasLoaded;
  final VoidCallback? onPressed;
  final VoidCallback? onForceRetry;
  final VoidCallback? onCachePressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: hasLoaded
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFE9F3FF),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                hasLoaded ? 'Pipeline completed' : 'Advanced Dio sample',
                style: TextStyle(
                  color: hasLoaded
                      ? const Color(0xFF2E7D32)
                      : AppTheme.primaryBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Advanced Dio control room',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Compare isolated clients, separate access tokens, custom timeouts, 401 refresh retry, cache, and failure mapping in one flow.',
              style: TextStyle(
                color: AppTheme.muted,
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onPressed,
              icon: isLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.sync_alt_outlined),
              label: Text(isLoading ? 'Calling APIs...' : 'Call APIs'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: onForceRetry,
              icon: const Icon(Icons.report_problem_outlined),
              label: const Text('Force 401 retry'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.ink,
                minimumSize: const Size.fromHeight(46),
                side: const BorderSide(color: AppTheme.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: onCachePressed,
              icon: const Icon(Icons.cached_outlined),
              label: const Text('Load from cache'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.ink,
                minimumSize: const Size.fromHeight(46),
                side: const BorderSide(color: AppTheme.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({
    required this.token,
    required this.refreshCount,
    required this.productsCount,
    required this.hasProfile,
    required this.productMode,
  });

  final String? token;
  final int refreshCount;
  final int productsCount;
  final bool hasProfile;
  final String productMode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 520;
        final columns = isWide ? 2 : 1;

        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: isWide ? 3.3 : 3.6,
          children: [
            MetricTile(
              icon: Icons.person_outline,
              label: 'Profile',
              value: hasProfile ? 'Loaded' : 'Waiting',
              accentColor: AppTheme.primaryBlue,
            ),
            MetricTile(
              icon: Icons.inventory_2_outlined,
              label: 'Products',
              value: '$productsCount items',
              accentColor: AppTheme.success,
            ),
            MetricTile(
              icon: Icons.refresh_outlined,
              label: 'Token refresh',
              value: '$refreshCount runs',
              accentColor: AppTheme.warning,
              backgroundColor: const Color(0xFFFFF7ED),
            ),
            MetricTile(
              icon: Icons.key_outlined,
              label: 'Products token',
              value: token ?? 'none',
              accentColor: const Color(0xFF7C4DFF),
              backgroundColor: const Color(0xFFF3E8FF),
            ),
            MetricTile(
              icon: Icons.cached_outlined,
              label: 'Product source',
              value: productMode,
              accentColor: const Color(0xFF14B8A6),
              backgroundColor: const Color(0xFFE6FFFB),
            ),
          ],
        );
      },
    );
  }
}

class _FailureBanner extends StatelessWidget {
  const _FailureBanner({required this.failure});

  final Failure failure;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFE53935), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              failure.message,
              style: const TextStyle(
                color: Color(0xFFC62828),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileResponse extends StatelessWidget {
  const _ProfileResponse({required this.profile});

  final ProfileEntity? profile;

  @override
  Widget build(BuildContext context) {
    return ResponseCard(
      title: 'Profile response',
      icon: Icons.account_circle_outlined,
      children: profile == null
          ? const [EmptyResponse(message: 'No profile loaded yet.')]
          : [
              FieldRow(label: 'ID', value: profile!.id.toString()),
              FieldRow(label: 'Name', value: profile!.name),
            ],
    );
  }
}

class _ProductsResponse extends StatelessWidget {
  const _ProductsResponse({required this.products});

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    return ResponseCard(
      title: 'Products response',
      icon: Icons.shopping_bag_outlined,
      children: products.isEmpty
          ? const [EmptyResponse(message: 'No products loaded yet.')]
          : [for (final product in products) _ProductRow(product: product)],
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
              child: Text(
                product.id.toString(),
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppTheme.ink,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
