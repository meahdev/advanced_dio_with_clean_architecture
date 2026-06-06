# Flutter Dio Advanced

A Flutter demo app for advanced Dio networking patterns.

GitHub: [meahdev/advanced_dio_with_clean_architecture](https://github.com/meahdev/advanced_dio_with_clean_architecture)

## What This Project Shows

- Separate Dio clients for separate APIs
- Separate access tokens per API
- Bloc-driven presentation state
- Per-client timeout policies
- Request, response, and error logging
- Redacted authorization headers in logs
- Token refresh on `401`
- Retry original request once after refresh
- Repository-level cache fallback
- Safe Dio error mapping into domain failures
- Fake backend adapter for local demos and tests

## Demo Actions

- **Call APIs**: loads profile and products from remote APIs
- **Force 401 retry**: expires the products token and proves refresh/retry works
- **Load from cache**: reads products from cache after the first remote load

## Article Draft

The Medium-ready article drafts are here:

[docs/medium_article.md](docs/medium_article.md)

[docs/medium_article.html](docs/medium_article.html)

## Verify

```sh
dart analyze
flutter test
```
