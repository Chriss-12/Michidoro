enum LocalUnlockPolicy {
  disabled,
  immediately,
  afterOneMinute,
  afterFiveMinutes;

  bool get isEnabled => this != disabled;

  Duration? get gracePeriod => switch (this) {
    disabled => null,
    immediately => Duration.zero,
    afterOneMinute => const Duration(minutes: 1),
    afterFiveMinutes => const Duration(minutes: 5),
  };
}
