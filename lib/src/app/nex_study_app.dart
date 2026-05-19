import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_theme.dart';
import '../data/datasources/mock_ai_data_source.dart';
import '../data/datasources/mock_auth_data_source.dart';
import '../data/datasources/mock_lecture_data_source.dart';
import '../data/repositories/ai_repository_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/lecture_repository_impl.dart';
import '../domain/usecases/analyze_lecture_usecase.dart';
import '../domain/usecases/get_recent_lectures_usecase.dart';
import '../domain/usecases/send_chat_message_usecase.dart';
import '../domain/usecases/sign_in_usecase.dart';
import '../domain/usecases/sign_out_usecase.dart';
import '../domain/usecases/sign_up_usecase.dart';
import '../domain/usecases/upload_lecture_usecase.dart';
import '../presentation/blocs/analysis/analysis_cubit.dart';
import '../presentation/blocs/auth/auth_bloc.dart';
import '../presentation/blocs/chat/chat_cubit.dart';
import '../presentation/blocs/home/home_cubit.dart';
import '../presentation/blocs/upload/upload_cubit.dart';
import '../presentation/pages/splash/splash_page.dart';

class NexStudyApp extends StatelessWidget {
  const NexStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepositoryImpl(dataSource: MockAuthDataSource());
    final lectureRepository = LectureRepositoryImpl(
      dataSource: MockLectureDataSource(),
    );
    final aiRepository = AiRepositoryImpl(dataSource: MockAiDataSource());

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: lectureRepository),
        RepositoryProvider.value(value: aiRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(
              signInUseCase: SignInUseCase(authRepository),
              signUpUseCase: SignUpUseCase(authRepository),
              signOutUseCase: SignOutUseCase(authRepository),
            )..add(const AuthStarted()),
          ),
          BlocProvider(
            create: (_) => HomeCubit(
              getRecentLecturesUseCase: GetRecentLecturesUseCase(
                lectureRepository,
              ),
            )..loadLectures(),
          ),
          BlocProvider(
            create: (_) => UploadCubit(
              uploadLectureUseCase: UploadLectureUseCase(lectureRepository),
            ),
          ),
          BlocProvider(
            create: (_) => AnalysisCubit(
              analyzeLectureUseCase: AnalyzeLectureUseCase(aiRepository),
            ),
          ),
          BlocProvider(
            create: (_) => ChatCubit(
              sendChatMessageUseCase: SendChatMessageUseCase(aiRepository),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'NexStudy',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          builder: (context, child) =>
              Directionality(textDirection: TextDirection.rtl, child: child!),
          home: const SplashPage(),
        ),
      ),
    );
  }
}
