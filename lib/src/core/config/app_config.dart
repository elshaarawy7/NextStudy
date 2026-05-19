enum AiProviderMode { mock, live }

class AppConfig {
  const AppConfig._();

  static const appName = 'NexStudy';
  static const aiMode = AiProviderMode.mock;
  static const useFirebase = false;
  static const studyGreeting = 'ذاكر محاضراتك بسهولة';
}
