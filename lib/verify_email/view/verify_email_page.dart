part of 'view.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const VerifyEmailPage());
  }

  @override
  Widget build(BuildContext context) {
    return const VerifyEmailView();
  }
}
