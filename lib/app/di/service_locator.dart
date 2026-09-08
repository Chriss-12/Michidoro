import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:pomodoro_app_v1/app/data/datasources/legacy_database_migrator.dart';
import 'package:pomodoro_app_v1/app/data/datasources/michifocus_database.dart';
import 'package:pomodoro_app_v1/app/state/application_data_refresh_coordinator.dart';
import 'package:pomodoro_app_v1/features/calendar/data/repositories/drift_calendar_events_repository.dart';
import 'package:pomodoro_app_v1/features/calendar/data/services/local_weekly_schedule_exporter.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/calendar_events_repository.dart';
import 'package:pomodoro_app_v1/features/calendar/domain/repositories/weekly_schedule_exporter.dart';
import 'package:pomodoro_app_v1/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:pomodoro_app_v1/features/focus_silence/data/repositories/file_focus_silence_preferences_repository.dart';
import 'package:pomodoro_app_v1/features/focus_silence/data/services/android_focus_silence_platform.dart';
import 'package:pomodoro_app_v1/features/focus_silence/domain/repositories/focus_silence_preferences_repository.dart';
import 'package:pomodoro_app_v1/features/focus_silence/domain/services/focus_silence_platform.dart';
import 'package:pomodoro_app_v1/features/focus_silence/presentation/controllers/focus_silence_controller.dart';
import 'package:pomodoro_app_v1/features/goals/data/repositories/drift_goals_repository.dart';
import 'package:pomodoro_app_v1/features/goals/domain/repositories/goals_repository.dart';
import 'package:pomodoro_app_v1/features/goals/presentation/controllers/goals_controller.dart';
import 'package:pomodoro_app_v1/features/pomodoro/data/repositories/drift_pomodoro_runtime_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/data/repositories/drift_pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_runtime_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/domain/repositories/pomodoro_sessions_repository.dart';
import 'package:pomodoro_app_v1/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:pomodoro_app_v1/features/quick_notes/data/repositories/drift_quick_notes_repository.dart';
import 'package:pomodoro_app_v1/features/quick_notes/domain/repositories/quick_notes_repository.dart';
import 'package:pomodoro_app_v1/features/quick_notes/presentation/controllers/quick_notes_controller.dart';
import 'package:pomodoro_app_v1/features/reports/data/repositories/drift_statistics_report_repository.dart';
import 'package:pomodoro_app_v1/features/reports/domain/repositories/statistics_report_repository.dart';
import 'package:pomodoro_app_v1/features/reports/domain/use_cases/generate_statistics_report.dart';
import 'package:pomodoro_app_v1/features/routines/data/repositories/drift_routines_repository.dart';
import 'package:pomodoro_app_v1/features/routines/domain/repositories/routines_repository.dart';
import 'package:pomodoro_app_v1/features/routines/presentation/controllers/routines_controller.dart';
import 'package:pomodoro_app_v1/features/settings/data/repositories/file_settings_repository.dart';
import 'package:pomodoro_app_v1/features/settings/domain/repositories/settings_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/drift_sync_exchange_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/file_device_identity_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/file_local_unlock_policy_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/file_sync_group_enrollment_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/repositories/file_sync_storage_config_repository.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_app_content_protection.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_device_bound_key_protector.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_device_name_provider.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_external_sync_app_launcher.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_local_device_authenticator.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_sync_data_folder_picker.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_sync_data_folder_validator.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_sync_group_manifest_discovery.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_sync_group_manifest_publisher.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_sync_operation_discovery.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/android_sync_operation_publisher.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/configured_sync_mutation_coordinator.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/drift_sync_conflict_resolution_service.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/drift_sync_incoming_application_service.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/drift_sync_initial_bootstrap_service.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/drift_sync_local_data_inspector.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/drift_sync_outbox_publication_service.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/drift_sync_recovery_snapshot_service.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/secure_sync_id_generator.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/sync_group_crypto.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/device_identity_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/local_unlock_policy_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/sync_group_enrollment_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/repositories/sync_storage_config_repository.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/device_bound_key_protector.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/device_name_provider.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/external_sync_app_launcher.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/local_device_authenticator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_conflict_resolution_service.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_data_folder_picker.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_data_folder_validator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_group_manifest_discovery.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_group_manifest_publisher.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_incoming_application_service.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_initial_bootstrap_service.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_local_data_inspector.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_mutation_coordinator.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_operation_discovery.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_operation_publisher.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_outbox_publication_service.dart';
import 'package:pomodoro_app_v1/features/sync/domain/services/sync_recovery_snapshot_service.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/device_identity_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/local_app_lock_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_group_enrollment_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_storage_controller.dart';
import 'package:pomodoro_app_v1/features/tasks/data/repositories/drift_tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/data/repositories/file_task_temporal_filter_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/task_temporal_filter_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:pomodoro_app_v1/features/tasks/presentation/controllers/tasks_controller.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> configureDependencies() async {
  await LegacyDatabaseMigrator.migrateIfNeeded();
  if (!serviceLocator.isRegistered<MichiFocusDatabase>()) {
    serviceLocator.registerSingleton<MichiFocusDatabase>(MichiFocusDatabase());
  }
  if (!serviceLocator.isRegistered<SettingsRepository>()) {
    serviceLocator.registerLazySingleton<SettingsRepository>(
      FileSettingsRepository.new,
    );
  }
  if (!serviceLocator.isRegistered<FocusSilencePreferencesRepository>()) {
    serviceLocator.registerLazySingleton<FocusSilencePreferencesRepository>(
      FileFocusSilencePreferencesRepository.new,
    );
  }
  if (!serviceLocator.isRegistered<FocusSilencePlatform>()) {
    serviceLocator.registerLazySingleton<FocusSilencePlatform>(
      AndroidFocusSilencePlatform.new,
    );
  }
  if (!serviceLocator.isRegistered<FocusSilenceController>()) {
    final focusSilenceController = FocusSilenceController(
      repository: serviceLocator<FocusSilencePreferencesRepository>(),
      platform: serviceLocator<FocusSilencePlatform>(),
    );
    serviceLocator.registerSingleton<FocusSilenceController>(
      focusSilenceController,
    );
    _loadInBackground(focusSilenceController.initialize());
  }

  if (!serviceLocator.isRegistered<LocalUnlockPolicyRepository>()) {
    serviceLocator.registerLazySingleton<LocalUnlockPolicyRepository>(
      FileLocalUnlockPolicyRepository.new,
    );
  }
  if (!serviceLocator.isRegistered<LocalDeviceAuthenticator>()) {
    serviceLocator.registerLazySingleton<LocalDeviceAuthenticator>(
      AndroidLocalDeviceAuthenticator.new,
    );
  }
  if (!serviceLocator.isRegistered<LocalAppLockController>()) {
    serviceLocator.registerSingleton<LocalAppLockController>(
      LocalAppLockController(
        repository: serviceLocator<LocalUnlockPolicyRepository>(),
        authenticator: serviceLocator<LocalDeviceAuthenticator>(),
        setContentProtection: const AndroidAppContentProtection().setEnabled,
      ),
    );
  }
  if (!serviceLocator.isRegistered<SyncStorageController>()) {
    serviceLocator
      ..registerLazySingleton<SyncStorageConfigRepository>(
        FileSyncStorageConfigRepository.new,
      )
      ..registerLazySingleton<SyncDataFolderPicker>(
        () => pickAndroidSyncDataFolder,
      )
      ..registerLazySingleton<SyncDataFolderValidator>(
        () => AndroidSyncDataFolderValidator().validate,
      )
      ..registerSingleton<SyncStorageController>(
        SyncStorageController(
          repository: serviceLocator<SyncStorageConfigRepository>(),
          folderPicker: serviceLocator<SyncDataFolderPicker>(),
          folderValidator: serviceLocator<SyncDataFolderValidator>(),
        ),
      );
  }
  if (!serviceLocator.isRegistered<SecureSyncIdGenerator>()) {
    serviceLocator.registerLazySingleton<SecureSyncIdGenerator>(
      SecureSyncIdGenerator.new,
    );
  }
  if (!serviceLocator.isRegistered<DeviceIdentityController>()) {
    serviceLocator
      ..registerLazySingleton<DeviceIdentityRepository>(
        FileDeviceIdentityRepository.new,
      )
      ..registerLazySingleton<DeviceNameProvider>(
        () => AndroidDeviceNameProvider().suggestedName,
      )
      ..registerSingleton<DeviceIdentityController>(
        DeviceIdentityController(
          repository: serviceLocator<DeviceIdentityRepository>(),
          deviceNameProvider: serviceLocator<DeviceNameProvider>(),
          idGenerator: serviceLocator<SecureSyncIdGenerator>(),
        ),
      );
  }
  if (!serviceLocator.isRegistered<DeviceBoundKeyProtector>()) {
    serviceLocator.registerLazySingleton<DeviceBoundKeyProtector>(
      AndroidDeviceBoundKeyProtector.new,
    );
  }
  if (!serviceLocator.isRegistered<ExternalSyncAppLauncher>()) {
    serviceLocator.registerLazySingleton<ExternalSyncAppLauncher>(
      () => const AndroidExternalSyncAppLauncher().call,
    );
  }
  if (!serviceLocator.isRegistered<SyncGroupManifestPublisher>()) {
    serviceLocator.registerLazySingleton<SyncGroupManifestPublisher>(
      AndroidSyncGroupManifestPublisher.new,
    );
  }
  if (!serviceLocator.isRegistered<SyncGroupManifestDiscovery>()) {
    serviceLocator.registerLazySingleton<SyncGroupManifestDiscovery>(
      () => const AndroidSyncGroupManifestDiscovery().call,
    );
  }
  if (!serviceLocator.isRegistered<SyncOperationPublisher>()) {
    serviceLocator.registerLazySingleton<SyncOperationPublisher>(
      AndroidSyncOperationPublisher.new,
    );
  }
  if (!serviceLocator.isRegistered<SyncOperationDiscovery>()) {
    serviceLocator.registerLazySingleton<SyncOperationDiscovery>(
      () => const AndroidSyncOperationDiscovery().call,
    );
  }
  if (!serviceLocator.isRegistered<SyncLocalDataInspector>()) {
    serviceLocator.registerLazySingleton<SyncLocalDataInspector>(
      () => DriftSyncLocalDataInspector(
        serviceLocator<MichiFocusDatabase>(),
      ).call,
    );
  }
  if (!serviceLocator.isRegistered<SyncRecoverySnapshotService>()) {
    serviceLocator.registerLazySingleton<SyncRecoverySnapshotService>(
      () => DriftSyncRecoverySnapshotService(
        database: serviceLocator<MichiFocusDatabase>(),
        crypto: serviceLocator<SyncGroupCrypto>(),
        idGenerator: serviceLocator<SecureSyncIdGenerator>(),
      ).call,
    );
  }
  if (!serviceLocator.isRegistered<SyncGroupEnrollmentRepository>()) {
    serviceLocator.registerLazySingleton<SyncGroupEnrollmentRepository>(
      FileSyncGroupEnrollmentRepository.new,
    );
  }
  if (!serviceLocator.isRegistered<SyncGroupCrypto>()) {
    serviceLocator.registerLazySingleton<SyncGroupCrypto>(SyncGroupCrypto.new);
  }
  if (!serviceLocator.isRegistered<DriftSyncExchangeRepository>()) {
    serviceLocator.registerLazySingleton<DriftSyncExchangeRepository>(
      () => DriftSyncExchangeRepository(serviceLocator<MichiFocusDatabase>()),
    );
  }
  if (!serviceLocator.isRegistered<SyncMutationCoordinator>()) {
    serviceLocator.registerLazySingleton<SyncMutationCoordinator>(
      () => ConfiguredSyncMutationCoordinator(
        storageRepository: serviceLocator<SyncStorageConfigRepository>(),
        enrollmentRepository: serviceLocator<SyncGroupEnrollmentRepository>(),
        identityRepository: serviceLocator<DeviceIdentityRepository>(),
        exchangeRepository: serviceLocator<DriftSyncExchangeRepository>(),
        idGenerator: serviceLocator<SecureSyncIdGenerator>(),
        database: serviceLocator<MichiFocusDatabase>(),
        readCurrentFields: (database, entityType, entityId) =>
            (serviceLocator<SyncConflictResolutionService>()
                    as DriftSyncConflictResolutionService)
                .readCurrentFields(database, entityType, entityId),
      ).call,
    );
  }
  if (!serviceLocator.isRegistered<SyncOutboxPublicationService>()) {
    serviceLocator.registerLazySingleton<SyncOutboxPublicationService>(
      () => DriftSyncOutboxPublicationService(
        repository: serviceLocator<DriftSyncExchangeRepository>(),
        crypto: serviceLocator<SyncGroupCrypto>(),
        publisher: serviceLocator<SyncOperationPublisher>(),
      ).call,
    );
  }
  if (!serviceLocator.isRegistered<SyncInitialBootstrapService>()) {
    serviceLocator.registerLazySingleton<SyncInitialBootstrapService>(
      () => DriftSyncInitialBootstrapService(
        database: serviceLocator<MichiFocusDatabase>(),
        exchangeRepository: serviceLocator<DriftSyncExchangeRepository>(),
        idGenerator: serviceLocator<SecureSyncIdGenerator>(),
        identityRepository: serviceLocator<DeviceIdentityRepository>(),
      ).call,
    );
  }
  if (!serviceLocator.isRegistered<SyncConflictResolutionService>()) {
    serviceLocator.registerLazySingleton<SyncConflictResolutionService>(
      () => DriftSyncConflictResolutionService(
        database: serviceLocator<MichiFocusDatabase>(),
        exchangeRepository: serviceLocator<DriftSyncExchangeRepository>(),
        idGenerator: serviceLocator<SecureSyncIdGenerator>(),
      ),
    );
  }
  if (!serviceLocator.isRegistered<SyncIncomingApplicationService>()) {
    serviceLocator.registerLazySingleton<SyncIncomingApplicationService>(
      () => DriftSyncIncomingApplicationService(
        exchangeRepository: serviceLocator<DriftSyncExchangeRepository>(),
        discovery: serviceLocator<SyncOperationDiscovery>(),
        crypto: serviceLocator<SyncGroupCrypto>(),
        readCurrentFields:
            (serviceLocator<SyncConflictResolutionService>()
                    as DriftSyncConflictResolutionService)
                .readCurrentFields,
      ).call,
    );
  }
  if (!serviceLocator.isRegistered<SyncGroupEnrollmentController>()) {
    serviceLocator.registerSingleton<SyncGroupEnrollmentController>(
      SyncGroupEnrollmentController(
        repository: serviceLocator<SyncGroupEnrollmentRepository>(),
        crypto: serviceLocator<SyncGroupCrypto>(),
        keyProtector: serviceLocator<DeviceBoundKeyProtector>(),
        authenticator: serviceLocator<LocalDeviceAuthenticator>(),
        idGenerator: serviceLocator<SecureSyncIdGenerator>(),
        manifestDiscovery: serviceLocator<SyncGroupManifestDiscovery>(),
        manifestPublisher: serviceLocator<SyncGroupManifestPublisher>(),
        localDataInspector: serviceLocator<SyncLocalDataInspector>(),
        recoverySnapshotService: serviceLocator<SyncRecoverySnapshotService>(),
        outboxPublicationService:
            serviceLocator<SyncOutboxPublicationService>(),
        incomingApplicationService:
            serviceLocator<SyncIncomingApplicationService>(),
        initialBootstrapService: serviceLocator<SyncInitialBootstrapService>(),
        identityRepository: serviceLocator<DeviceIdentityRepository>(),
        externalSyncAppLauncher: serviceLocator<ExternalSyncAppLauncher>(),
        conflictResolutionService:
            serviceLocator<SyncConflictResolutionService>(),
        refreshApplicationData: refreshApplicationData,
      ),
    );
  }

  if (!serviceLocator.isRegistered<GoalsDao>()) {
    serviceLocator
      ..registerLazySingleton<GoalsDao>(
        () => GoalsDao(serviceLocator<MichiFocusDatabase>()),
      )
      ..registerLazySingleton<GoalsRepository>(
        () => DriftGoalsRepository(
          serviceLocator<GoalsDao>(),
          sync: serviceLocator<SyncMutationCoordinator>(),
          idGenerator: serviceLocator<SecureSyncIdGenerator>(),
        ),
      );
  }

  if (!serviceLocator.isRegistered<GoalsController>()) {
    final goalsController = GoalsController(
      repository: serviceLocator<GoalsRepository>(),
    );
    serviceLocator.registerSingleton<GoalsController>(goalsController);
    _loadInBackground(goalsController.loadGoals());
  }

  if (!serviceLocator.isRegistered<PomodoroSessionsDao>()) {
    serviceLocator
      ..registerLazySingleton<PomodoroSessionsDao>(
        () => PomodoroSessionsDao(serviceLocator<MichiFocusDatabase>()),
      )
      ..registerLazySingleton<PomodoroSessionsRepository>(
        () => DriftPomodoroSessionsRepository(
          serviceLocator<PomodoroSessionsDao>(),
        ),
      )
      ..registerLazySingleton<PomodoroRuntimeDao>(
        () => PomodoroRuntimeDao(serviceLocator<MichiFocusDatabase>()),
      )
      ..registerLazySingleton<PomodoroRuntimeRepository>(
        () => DriftPomodoroRuntimeRepository(
          serviceLocator<PomodoroRuntimeDao>(),
        ),
      );
  }

  if (!serviceLocator.isRegistered<PomodoroController>()) {
    final pomodoroController = PomodoroController(
      repository: serviceLocator<PomodoroSessionsRepository>(),
      runtimeRepository: serviceLocator<PomodoroRuntimeRepository>(),
    );
    serviceLocator.registerSingleton<PomodoroController>(pomodoroController);
    _loadInBackground(pomodoroController.initialize());
  }

  if (!serviceLocator.isRegistered<CalendarEventsDao>()) {
    serviceLocator
      ..registerLazySingleton<CalendarEventsDao>(
        () => CalendarEventsDao(serviceLocator<MichiFocusDatabase>()),
      )
      ..registerLazySingleton<CalendarEventsRepository>(
        () => DriftCalendarEventsRepository(
          serviceLocator<CalendarEventsDao>(),
          sync: serviceLocator<SyncMutationCoordinator>(),
          idGenerator: serviceLocator<SecureSyncIdGenerator>(),
        ),
      );
  }

  if (!serviceLocator.isRegistered<CalendarController>()) {
    final calendarController = CalendarController(
      repository: serviceLocator<CalendarEventsRepository>(),
    );
    serviceLocator.registerSingleton<CalendarController>(calendarController);
    _loadInBackground(calendarController.loadEvents());
  }
  if (!serviceLocator.isRegistered<WeeklyScheduleExporter>()) {
    serviceLocator.registerLazySingleton<WeeklyScheduleExporter>(
      LocalWeeklyScheduleExporter.new,
    );
  }

  if (!serviceLocator.isRegistered<QuickNotesDao>()) {
    serviceLocator
      ..registerLazySingleton<QuickNotesDao>(
        () => QuickNotesDao(serviceLocator<MichiFocusDatabase>()),
      )
      ..registerLazySingleton<QuickNotesRepository>(
        () => DriftQuickNotesRepository(
          serviceLocator<QuickNotesDao>(),
          sync: serviceLocator<SyncMutationCoordinator>(),
          idGenerator: serviceLocator<SecureSyncIdGenerator>(),
        ),
      );
  }
  if (!serviceLocator.isRegistered<QuickNotesController>()) {
    final controller = QuickNotesController(
      repository: serviceLocator<QuickNotesRepository>(),
    );
    serviceLocator.registerSingleton<QuickNotesController>(controller);
  }

  if (!serviceLocator.isRegistered<TasksDao>()) {
    serviceLocator
      ..registerLazySingleton<TasksDao>(
        () => TasksDao(serviceLocator<MichiFocusDatabase>()),
      )
      ..registerLazySingleton<TasksRepository>(
        () => DriftTasksRepository(
          serviceLocator<TasksDao>(),
          sync: serviceLocator<SyncMutationCoordinator>(),
          idGenerator: serviceLocator<SecureSyncIdGenerator>(),
        ),
      );
  }

  if (!serviceLocator.isRegistered<RoutinesDao>()) {
    serviceLocator.registerLazySingleton<RoutinesDao>(
      () => RoutinesDao(serviceLocator<MichiFocusDatabase>()),
    );
  }
  if (!serviceLocator.isRegistered<RoutinesRepository>()) {
    serviceLocator.registerLazySingleton<RoutinesRepository>(
      () => DriftRoutinesRepository(
        serviceLocator<RoutinesDao>(),
        sync: serviceLocator<SyncMutationCoordinator>(),
      ),
    );
  }
  if (!serviceLocator.isRegistered<RoutinesController>()) {
    final routinesController = RoutinesController(
      repository: serviceLocator<RoutinesRepository>(),
    );
    serviceLocator.registerSingleton<RoutinesController>(routinesController);
  }

  if (!serviceLocator.isRegistered<GenerateStatisticsReport>()) {
    serviceLocator
      ..registerLazySingleton<ReportsDao>(
        () => ReportsDao(serviceLocator<MichiFocusDatabase>()),
      )
      ..registerLazySingleton<StatisticsReportRepository>(
        () => DriftStatisticsReportRepository(serviceLocator<ReportsDao>()),
      )
      ..registerLazySingleton<GenerateStatisticsReport>(
        () => GenerateStatisticsReport(
          repository: serviceLocator<StatisticsReportRepository>(),
        ),
      );
  }

  if (!serviceLocator.isRegistered<TasksController>()) {
    if (!serviceLocator.isRegistered<TaskTemporalFilterRepository>()) {
      serviceLocator.registerLazySingleton<TaskTemporalFilterRepository>(
        FileTaskTemporalFilterRepository.new,
      );
    }

    final tasksController = TasksController(
      repository: serviceLocator<TasksRepository>(),
      temporalFilterRepository: serviceLocator<TaskTemporalFilterRepository>(),
    );
    serviceLocator.registerSingleton<TasksController>(tasksController);
  }

  if (!serviceLocator.isRegistered<ApplicationDataRefreshCoordinator>()) {
    serviceLocator.registerSingleton<ApplicationDataRefreshCoordinator>(
      ApplicationDataRefreshCoordinator(
        refreshers: [
          serviceLocator<GoalsController>().loadGoals,
          serviceLocator<TasksController>().loadTasks,
          serviceLocator<CalendarController>().loadEvents,
          serviceLocator<RoutinesController>().load,
          serviceLocator<QuickNotesController>().load,
        ],
      ),
    );
  }
}

void _loadInBackground(Future<void> load) {
  unawaited(
    load.catchError((Object error, StackTrace stackTrace) {
      Zone.current.handleUncaughtError(error, stackTrace);
    }),
  );
}

Future<void> refreshApplicationData() {
  if (!serviceLocator.isRegistered<ApplicationDataRefreshCoordinator>()) {
    return Future.value();
  }
  return serviceLocator<ApplicationDataRefreshCoordinator>().refresh();
}
