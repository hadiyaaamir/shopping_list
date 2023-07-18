part of 'view.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SignupPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Sign Up'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocProvider(
          create: (context) {
            return SignupBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
            );
          },
          child: const SignupForm(),
        ),
      ),
    );
  }
}
