enum FocusSilenceProfile { alarmsOnly, noInterruptions }

class FocusSilencePreferences {
  const FocusSilencePreferences({
    this.enableWithPomodoro = false,
    this.profile = FocusSilenceProfile.alarmsOnly,
  });

  final bool enableWithPomodoro;
  final FocusSilenceProfile profile;

  FocusSilencePreferences copyWith({
    bool? enableWithPomodoro,
    FocusSilenceProfile? profile,
  }) {
    return FocusSilencePreferences(
      enableWithPomodoro: enableWithPomodoro ?? this.enableWithPomodoro,
      profile: profile ?? this.profile,
    );
  }
}

class FocusSilenceCapability {
  const FocusSilenceCapability({
    required this.isSupported,
    required this.isAuthorized,
    required this.isActive,
    required this.apiLevel,
  });

  const FocusSilenceCapability.unsupported()
    : isSupported = false,
      isAuthorized = false,
      isActive = false,
      apiLevel = 0;

  final bool isSupported;
  final bool isAuthorized;
  final bool isActive;
  final int apiLevel;
}
