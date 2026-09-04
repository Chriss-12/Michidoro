typedef ApplicationDataRefresher = Future<void> Function();

class ApplicationDataRefreshCoordinator {
  ApplicationDataRefreshCoordinator({
    required Iterable<ApplicationDataRefresher> refreshers,
  }) : _refreshers = List.unmodifiable(refreshers);

  final List<ApplicationDataRefresher> _refreshers;
  Future<void>? _inFlight;

  Future<void> refresh() {
    final active = _inFlight;
    if (active != null) return active;

    late final Future<void> operation;
    operation =
        Future.wait(
          _refreshers.map((refresh) => refresh()),
        ).then<void>(
          (_) => _clear(operation),
          onError: (Object error, StackTrace stackTrace) {
            _clear(operation);
            Error.throwWithStackTrace(error, stackTrace);
          },
        );
    _inFlight = operation;
    return operation;
  }

  void _clear(Future<void> operation) {
    if (identical(_inFlight, operation)) _inFlight = null;
  }
}
