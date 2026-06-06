# Advanced Dio in Flutter: Clean Architecture for Multiple APIs and Third-Party Integrations

Most Flutter apps start with one `Dio` instance and one access token. That works for simple projects, but real apps usually grow past that quickly.

Not every app needs this setup. Many apps are perfectly fine with one backend and one access token. But sometimes you need to integrate a third-party API independently from your main backend. That third-party API may have its own base URL, access token, timeout requirements, refresh behavior, logging needs, and cache rules.

GitHub: [https://github.com/meahdev/advanced_dio_with_clean_architecture](https://github.com/meahdev/advanced_dio_with_clean_architecture)

## Why Does This Matter?

Imagine your app already has a normal backend for profile, authentication, settings, and dashboard data. Later, you need to connect an independent third-party service for products, privacy scans, payments, maps, analytics, or identity verification.

That external service may not behave like your backend. It may require a separate token. It may expire that token differently. It may need a longer timeout. It may have a different retry rule. It may return errors in another shape. You do not want those rules mixed into your normal app API client.

This is why multiple Dio clients matter. You can keep your main API stable while adding a separate client for the third-party API. Each client gets its own configuration, but the app still uses one clean architecture.

You may need:

- one API for your own backend
- another API for a partner service
- separate access tokens for each API
- different timeout rules
- token refresh on `401`
- retrying the failed request only once
- request and response logs
- local cache fallback
- safe error mapping for the UI
- centralized dependency injection with `get_it`
- Bloc-driven presentation state

This article walks through an advanced Dio setup that demonstrates all of those pieces in one small Flutter app.

## Clean Architecture and Centralized Setup

The project follows a small clean architecture structure:

```text
lib/
  app/
    bootstrap.dart
    di/
      injection_container.dart
      core_injection.dart
      datasources_injection.dart
      repositories_injection.dart
      usecases_injection.dart
  core/
    network/
    storage/
    error/
  features/
    profile/
      data/
      domain/
    products/
      data/
      domain/
    api_demo/
      presentation/
        bloc/
        screens/
        widgets/
```

The idea is simple:

- `core` owns reusable infrastructure such as Dio, logging, token storage, cache, and errors.
- `features/*/data` owns models, remote data sources, local data sources, and repository implementations.
- `features/*/domain` owns entities, repository contracts, and use cases.
- `features/*/presentation` owns Bloc, screens, and widgets.
- `app/di` wires everything together with `get_it`.

This keeps `main.dart` clean:

```dart
Future<void> main() async {
  await bootstrap();
  runApp(const MyApp());
}
```

And `bootstrap()` does only startup work:

```dart
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
}
```

The dependency container is split into focused files:

```dart
final sl = GetIt.instance;

Future<void> setupDependencies() async {
  await setupCore(sl);
  await setupDataSources(sl);
  await setupRepositories(sl);
  await setupUseCases(sl);
  await setupBlocs(sl);
}
```

This is the same style used by larger apps: register core services first, then data sources, then repositories, then use cases and presentation state.

The API demo presentation layer uses a Bloc:

```text
api_demo/
  presentation/
    bloc/
      api_demo_bloc.dart
      api_demo_event.dart
      api_demo_state.dart
    screens/
      api_demo_screen.dart
    widgets/
```

The UI dispatches events:

```dart
context.read<ApiDemoBloc>().add(const ApiDemoCallApisRequested());
context.read<ApiDemoBloc>().add(const ApiDemoForce401RetryRequested());
context.read<ApiDemoBloc>().add(const ApiDemoLoadFromCacheRequested());
```

The Bloc owns loading, failure, profile, product list, product source, token, and refresh count state. The screen only renders `ApiDemoState`.

## What We Are Building

The sample app has two API clients:

- **Users API**
  - uses `appToken`
  - uses `AppApiInterceptor`
  - has short timeout values

- **Products API**
  - uses `productsToken`
  - uses `ProductsApiInterceptor`
  - has longer timeout values
  - refreshes token on `401`
  - retries the original request
  - writes successful response into cache

The UI includes three test actions:

- **Call APIs**: performs normal profile and products calls
- **Force 401 retry**: expires the products token and proves refresh/retry works
- **Load from cache**: reads products from cache without calling the products API again

## Centralized Dio Client Factory

The project uses one factory to create every Dio client.

```dart
class ApiClientFactory {
  static const usersConnectTimeout = Duration(seconds: 5);
  static const usersReceiveTimeout = Duration(seconds: 10);
  static const productsConnectTimeout = Duration(seconds: 20);
  static const productsReceiveTimeout = Duration(seconds: 45);

  ApiClientFactory({
    required InMemoryTokenStore tokenStore,
    HttpClientAdapter? appAdapter,
    HttpClientAdapter? productsAdapter,
  }) : _tokenStore = tokenStore,
       _appAdapter = appAdapter,
       _productsAdapter = productsAdapter;

  final InMemoryTokenStore _tokenStore;
  final HttpClientAdapter? _appAdapter;
  final HttpClientAdapter? _productsAdapter;

  Dio usersApi() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiBase.usersApi,
        connectTimeout: usersConnectTimeout,
        receiveTimeout: usersReceiveTimeout,
      ),
    );

    if (_appAdapter != null) dio.httpClientAdapter = _appAdapter;

    dio.interceptors.addAll([
      AppApiInterceptor(_tokenStore),
      ApiLogInterceptor('USERS_API'),
    ]);
    return dio;
  }

  Dio productsApi() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiBase.productsApi,
        connectTimeout: productsConnectTimeout,
        receiveTimeout: productsReceiveTimeout,
      ),
    );

    if (_productsAdapter != null) dio.httpClientAdapter = _productsAdapter;

    final retryClient = Dio(
      BaseOptions(
        connectTimeout: productsConnectTimeout,
        receiveTimeout: productsReceiveTimeout,
      ),
    );
    if (_productsAdapter != null) {
      retryClient.httpClientAdapter = _productsAdapter;
    }
    retryClient.interceptors.add(ApiLogInterceptor('PRODUCTS_API_RETRY'));

    dio.interceptors.addAll([
      ProductsApiInterceptor(tokenStore: _tokenStore, retryClient: retryClient),
      ApiLogInterceptor('PRODUCTS_API'),
    ]);
    return dio;
  }
}
```

The important idea is that each backend gets its own configuration. You are not forced to share base URLs, headers, tokens, timeout values, or interceptors.

## Separate Access Tokens

For demo purposes, this project uses an in-memory token store:

```dart
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
```

In production, replace this with secure storage and real refresh endpoints. The workflow stays the same.

## App Token Interceptor

The app API uses the normal app token.

```dart
class AppApiInterceptor extends QueuedInterceptor {
  AppApiInterceptor(this._tokenStore);

  final InMemoryTokenStore _tokenStore;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStore.getAppToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      options.headers.remove('Authorization');
    }
    handler.next(options);
  }
}
```

Notice that the interceptor removes empty authorization headers. That avoids sending bad headers such as `Bearer null`.

## Products Token Refresh and Retry

The products API has its own token. If the token fails with `401`, the interceptor refreshes the token and retries the original request once.

```dart
class ProductsApiInterceptor extends QueuedInterceptor {
  ProductsApiInterceptor({
    required InMemoryTokenStore tokenStore,
    required Dio retryClient,
  }) : _tokenStore = tokenStore,
       _retryClient = retryClient;

  final InMemoryTokenStore _tokenStore;
  final Dio _retryClient;
  Completer<void>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStore.getProductsToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      options.headers.remove('Authorization');
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final alreadyRetried = err.requestOptions.extra['retry'] == true;
    final shouldRefresh = err.response?.statusCode == 401 && !alreadyRetried;

    if (!shouldRefresh) {
      handler.next(err);
      return;
    }

    err.requestOptions.extra['retry'] = true;

    try {
      await _refreshTokenSingleFlight();

      final newToken = await _tokenStore.getProductsToken();
      if (newToken == null || newToken.isEmpty) {
        handler.reject(err);
        return;
      }

      final options = err.requestOptions;
      final retryHeaders = Map<String, dynamic>.from(options.headers);
      retryHeaders['Authorization'] = 'Bearer $newToken';

      final response = await _retryClient.request<dynamic>(
        options.uri.toString(),
        data: options.data,
        queryParameters: options.queryParameters,
        options: Options(
          method: options.method,
          headers: retryHeaders,
          contentType: options.contentType,
          responseType: options.responseType,
        ),
      );

      handler.resolve(response);
    } catch (_) {
      handler.reject(err);
    }
  }

  Future<void> _refreshTokenSingleFlight() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    final completer = Completer<void>();
    _refreshCompleter = completer;

    try {
      await _tokenStore.refreshProductsToken();
      completer.complete();
    } catch (error, stackTrace) {
      completer.completeError(error, stackTrace);
    } finally {
      _refreshCompleter = null;
    }
  }
}
```

There are three important details here:

1. `extra['retry']` prevents infinite retry loops.
2. `_refreshCompleter` ensures only one refresh happens at a time.
3. The retry request preserves method, headers, body, query params, content type, and response type.

## Logging Requests, Responses, and Errors

Every client gets a logging interceptor.

```dart
class ApiLogInterceptor extends Interceptor {
  ApiLogInterceptor(this.clientName);

  final String clientName;
  final JsonEncoder _jsonEncoder = const JsonEncoder.withIndent('  ');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _write('REQUEST ${options.method} ${options.uri}');
    _write('Headers: ${_encode(_redactHeaders(options.headers))}');
    if (options.queryParameters.isNotEmpty) {
      _write('Query: ${_encode(options.queryParameters)}');
    }
    if (options.data != null) {
      _write('Body: ${_encode(_normalizeBody(options.data))}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _write('RESPONSE ${response.statusCode} ${response.realUri}');
    _write('Data: ${_encode(response.data)}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _write(
      'ERROR ${err.response?.statusCode ?? '-'} ${err.requestOptions.uri}',
    );
    _write('Type: ${err.type}');
    _write('Message: ${err.message}');
    if (err.response?.data != null) {
      _write('Error data: ${_encode(err.response?.data)}');
    }
    handler.next(err);
  }
}
```

Authorization headers are redacted, so logs show that a token exists without exposing the full secret.

Example log:

```text
[DIO] [PRODUCTS_API] REQUEST GET https://dummyjson.com/products
[DIO] [PRODUCTS_API] Headers: {
  "Authorization": "Bearer expi...oken"
}
[DIO] [PRODUCTS_API_AUTH] TOKEN_FAILURE 401 https://dummyjson.com/products
[DIO] [PRODUCTS_API_AUTH] REFRESH_START productsToken
[DIO] [PRODUCTS_API_AUTH] REFRESH_SUCCESS productsToken=fres...oken
[DIO] [PRODUCTS_API_AUTH] RETRY_START GET https://dummyjson.com/products
[DIO] [PRODUCTS_API_RETRY] RESPONSE 200 https://dummyjson.com/products
```

## Repository Cache

The product repository reads from cache unless the caller forces a remote refresh.

```dart
class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl({
    required ProductRemoteDataSource remote,
    required ProductLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final ProductRemoteDataSource _remote;
  final ProductLocalDataSource _local;

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchProducts({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await _local.getCachedProducts();
      if (cached != null && cached.isNotEmpty) {
        return Right(cached.map((model) => model.toEntity()).toList());
      }
    }

    return safeApiCall(() async {
      final remoteModels = await _remote.fetchProducts();
      await _local.cacheProducts(remoteModels);
      return remoteModels.map((model) => model.toEntity()).toList();
    });
  }
}
```

The UI has a **Load from cache** button. After the first remote call, pressing it loads products from cache and skips the products API.

## Safe API Calls

Dio exceptions should not leak everywhere in your app. The repository converts them into domain-level failures.

```dart
Future<Either<Failure, T>> safeApiCall<T>(
  Future<T> Function() request,
) async {
  try {
    final result = await request();
    return Right(result);
  } on DioException catch (error) {
    final statusCode = error.response?.statusCode;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const Left(NetworkFailure('Network timeout'));
    }

    if (statusCode == 401) {
      return const Left(TokenFailure('Unauthorized'));
    }

    if (statusCode == 400 || statusCode == 422 || statusCode == 429) {
      return Left(ClientFailure(_messageFrom(error.response?.data)));
    }

    if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
      return const Left(ServerFailure('Server error. Try again later.'));
    }

    return const Left(ServerFailure('Something went wrong'));
  } catch (_) {
    return const Left(ServerFailure('Unexpected error'));
  }
}
```

This keeps UI code clean because it only deals with predictable failure objects.

## Demo UI

The demo screen explains the network architecture directly:

- client policies
- customization options
- request pipeline
- token refresh count
- products token state
- product source: remote refresh or cache allowed
- profile and product responses

The screen is not just a pretty UI. It is a control room for testing advanced Dio behavior.

## What to Replace in Production

The architecture is production-ready, but the demo uses fake pieces so the flow is easy to test.

Replace:

- `InMemoryTokenStore` with secure storage or an auth service
- `FakeBackendAdapter` with real HTTP
- demo refresh logic with a real refresh endpoint
- console logging with a release-safe logging strategy
- manual **Force 401 retry** button with debug-only tooling

Keep:

- separate clients
- separate tokens
- retry-once guard
- single-flight refresh
- redacted logs
- cache strategy
- safe failure mapping

## Final Thoughts

An advanced Dio setup is not about adding more code for its own sake. It is about making network behavior explicit, testable, and safe.

With separate clients, token-aware interceptors, retry logic, logging, cache, and failure mapping, your Flutter app becomes much easier to reason about when API behavior gets complicated.
