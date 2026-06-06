import '../../../../core/error/failure.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../profile/domain/entities/profile_entity.dart';

class ApiDemoState {
  const ApiDemoState({
    this.isLoading = false,
    this.failure,
    this.profile,
    this.products = const [],
    this.productMode = 'Not loaded',
    this.productsToken,
    this.refreshCount = 0,
  });

  final bool isLoading;
  final Failure? failure;
  final ProfileEntity? profile;
  final List<ProductEntity> products;
  final String productMode;
  final String? productsToken;
  final int refreshCount;

  bool get hasLoaded => profile != null && products.isNotEmpty;

  ApiDemoState copyWith({
    bool? isLoading,
    Object? failure = _sentinel,
    Object? profile = _sentinel,
    List<ProductEntity>? products,
    String? productMode,
    Object? productsToken = _sentinel,
    int? refreshCount,
  }) {
    return ApiDemoState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure == _sentinel ? this.failure : failure as Failure?,
      profile: profile == _sentinel ? this.profile : profile as ProfileEntity?,
      products: products ?? this.products,
      productMode: productMode ?? this.productMode,
      productsToken: productsToken == _sentinel
          ? this.productsToken
          : productsToken as String?,
      refreshCount: refreshCount ?? this.refreshCount,
    );
  }

  static const Object _sentinel = Object();
}
