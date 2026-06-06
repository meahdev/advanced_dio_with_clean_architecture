import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/token_store.dart';
import '../../../products/domain/usecases/fetch_products_usecase.dart';
import '../../../profile/domain/usecases/fetch_profile_usecase.dart';
import 'api_demo_event.dart';
import 'api_demo_state.dart';

class ApiDemoBloc extends Bloc<ApiDemoEvent, ApiDemoState> {
  ApiDemoBloc({
    required FetchProfileUseCase fetchProfile,
    required FetchProductsUseCase fetchProducts,
    required InMemoryTokenStore tokenStore,
  }) : _fetchProfile = fetchProfile,
       _fetchProducts = fetchProducts,
       _tokenStore = tokenStore,
       super(
         ApiDemoState(
           productsToken: tokenStore.productsToken,
           refreshCount: tokenStore.refreshCount,
         ),
       ) {
    on<ApiDemoCallApisRequested>(_onCallApisRequested);
    on<ApiDemoForce401RetryRequested>(_onForce401RetryRequested);
    on<ApiDemoLoadFromCacheRequested>(_onLoadFromCacheRequested);
  }

  final FetchProfileUseCase _fetchProfile;
  final FetchProductsUseCase _fetchProducts;
  final InMemoryTokenStore _tokenStore;

  Future<void> _onCallApisRequested(
    ApiDemoCallApisRequested event,
    Emitter<ApiDemoState> emit,
  ) {
    return _loadApiData(emit, forceRefresh: true);
  }

  Future<void> _onForce401RetryRequested(
    ApiDemoForce401RetryRequested event,
    Emitter<ApiDemoState> emit,
  ) async {
    await _tokenStore.expireProductsToken();
    emit(
      state.copyWith(
        products: const [],
        productsToken: _tokenStore.productsToken,
      ),
    );
    await _loadApiData(emit, forceRefresh: true);
  }

  Future<void> _onLoadFromCacheRequested(
    ApiDemoLoadFromCacheRequested event,
    Emitter<ApiDemoState> emit,
  ) {
    return _loadApiData(emit, forceRefresh: false);
  }

  Future<void> _loadApiData(
    Emitter<ApiDemoState> emit, {
    required bool forceRefresh,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        failure: null,
        productMode: forceRefresh ? 'Remote refresh' : 'Cache allowed',
        productsToken: _tokenStore.productsToken,
        refreshCount: _tokenStore.refreshCount,
      ),
    );

    final profileResult = await _fetchProfile();
    final productsResult = await _fetchProducts(forceRefresh: forceRefresh);

    profileResult.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            failure: failure,
            productsToken: _tokenStore.productsToken,
            refreshCount: _tokenStore.refreshCount,
          ),
        );
      },
      (profile) {
        productsResult.fold(
          (failure) {
            emit(
              state.copyWith(
                isLoading: false,
                profile: profile,
                failure: failure,
                productsToken: _tokenStore.productsToken,
                refreshCount: _tokenStore.refreshCount,
              ),
            );
          },
          (products) {
            emit(
              state.copyWith(
                isLoading: false,
                failure: null,
                profile: profile,
                products: products,
                productsToken: _tokenStore.productsToken,
                refreshCount: _tokenStore.refreshCount,
              ),
            );
          },
        );
      },
    );
  }
}
