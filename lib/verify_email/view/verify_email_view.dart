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
    return const Scaffold(
      appBar: CustomAppBar(title: 'Verify Email'),
    );
  }
}
