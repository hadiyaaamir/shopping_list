part of 'view.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  void initState() {
    super.initState();

    context
        .read<AuthenticationBloc>()
        .add(AuthenticationSendVerificationEmail());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Verify Email'),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          print('state.status: ${state.status}');
          if (state.status == AuthenticationStatus.unverified &&
              context.read<AuthenticationRepository>().isEmailVerfied) {
            context
                .read<AuthenticationBloc>()
                .add(AuthenticationEmailVerified());
          }
        },
        child: Container(),
      ),
    );
  }
}
