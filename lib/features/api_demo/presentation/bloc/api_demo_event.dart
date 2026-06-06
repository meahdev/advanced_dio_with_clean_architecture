sealed class ApiDemoEvent {
  const ApiDemoEvent();
}

class ApiDemoCallApisRequested extends ApiDemoEvent {
  const ApiDemoCallApisRequested();
}

class ApiDemoForce401RetryRequested extends ApiDemoEvent {
  const ApiDemoForce401RetryRequested();
}

class ApiDemoLoadFromCacheRequested extends ApiDemoEvent {
  const ApiDemoLoadFromCacheRequested();
}
