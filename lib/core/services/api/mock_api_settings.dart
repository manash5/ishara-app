import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mock_api_settings.g.dart';

/// Failures the mock API can fake, switched from the debug `/gallery`.
enum MockApiSimulation {
  none('Normal'),
  offline('Offline'),
  unauthorized('401 once'),
  sessionExpired('Session expired'),
  notFound('404'),
  serverError('500');

  const MockApiSimulation(this.label);
  final String label;
}

/// The mock API's current simulation (debug only; ignored by a real server).
@Riverpod(keepAlive: true)
class MockApiSettings extends _$MockApiSettings {
  @override
  MockApiSimulation build() => MockApiSimulation.none;

  void simulate(MockApiSimulation simulation) => state = simulation;
}
