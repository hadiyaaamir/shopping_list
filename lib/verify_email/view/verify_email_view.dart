part of 'view.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  Timer? timer;

  late final AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();

    _authenticationBloc = context.read<AuthenticationBloc>();
    _authenticationBloc.add(AuthenticationSendVerificationEmail());

    // if (!) {
    //   sendVerificationEmail();
    timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _authenticationBloc.add(AuthenticationEmailVerified()),
    );
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Verify Email'),
    );
  }
}
