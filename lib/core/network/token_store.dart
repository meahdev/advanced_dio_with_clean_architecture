/// Minimal token store used by the demo.
///
/// In a real Flutter app, app tokens and secondary API tokens would usually be stored
/// through a secure storage wrapper.
class InMemoryTokenStore {
  String? appToken;
  String? productsToken;
  int refreshCount = 0;

  Future<String?> getAppToken() async => appToken;

  Future<String?> getProductsToken() async => productsToken;

  Future<void> expireProductsToken() async {
    productsToken = 'expired-products-token';
  }

  Future<void> refreshProductsToken() async {
    refreshCount++;
    await Future<void>.delayed(const Duration(milliseconds: 200));
    productsToken = 'fresh-products-token';
  }
}
