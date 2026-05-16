enum AiProviderMode { mock, live }

class AppConfig {
  const AppConfig._();

  static const appName = 'NexStudy';
  static const aiMode = AiProviderMode.mock;
  static const useFirebase = false;
  static const studyGreeting =
      'Learn faster with simple notes, focused quizzes, and calm AI help.';
}
