import 'package:flutter/material.dart';
import 'package:blockchain/data/models/task_model.dart';
import 'package:blockchain/presentation/screens/teacher/generatecode_screen.dart';
import 'package:blockchain/presentation/screens/login_page.dart';
import 'package:blockchain/presentation/screens/sudent/my_homepage.dart';
import 'package:blockchain/presentation/screens/onboarding.dart';
import 'package:blockchain/presentation/screens/signup_page.dart';
import 'package:blockchain/presentation/screens/teacher/teachhome.dart';
import 'package:blockchain/presentation/screens/teacher/upload.dart';
import 'package:blockchain/presentation/screens/welcome_page.dart';
import 'package:blockchain/shared/constants/strings.dart';

class AppRoute {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        {
          return MaterialPageRoute(builder: (_) => const OnboardingPage());
        }
      case teacherhome:
        {
          return MaterialPageRoute(builder: (_) => const TeacherHome());
        }

      case welcomepage:
        {
          return MaterialPageRoute(builder: (_) => const WelcomePage());
        }

      case loginpage:
        {
          return MaterialPageRoute(builder: (_) => const LoginPage());
        }

      case signuppage:
        {
          return MaterialPageRoute(builder: (_) => const SignUpPage());
        }
      case homepage:
        {
          return MaterialPageRoute(builder: (_) => const StudentHome());
        }
      case generatecodepage:
        {
          final task = settings.arguments as TaskModel?;
          return MaterialPageRoute(
              builder: (_) => GenerateCodePage(
                    task: task,
                  ));
        }
      default:
        throw 'No Page Found!!';
    }
  }
}
