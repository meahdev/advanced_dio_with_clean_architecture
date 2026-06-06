/// Base URLs used by the app.
///
/// A production app often talks to more than one backend. Keeping base URLs in
/// one place makes it obvious which API domain a Dio client belongs to.
class ApiBase {
  const ApiBase._();

  static const usersApi = 'https://jsonplaceholder.typicode.com';
  static const productsApi = 'https://dummyjson.com';
}
