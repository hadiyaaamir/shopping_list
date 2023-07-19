part of 'view.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const VerifyEmailPage());
  }

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? timer;
  late final AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();

    _authenticationBloc = context.read<AuthenticationBloc>();
    _authenticationBloc.add(AuthenticationSendVerificationEmail());

    timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _authenticationBloc.add(AuthenticationCheckEmail()),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Verify Email'),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Confirm Your Email Address',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          Wrap(
            children: [
              const Center(
                  child: Text('A verification email has been sent to you at')),
              Center(
                child: Text(
                  _authenticationBloc.state.user.email,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Button(
            label: 'Resend Email',
            onPressed: () =>
                _authenticationBloc.add(AuthenticationSendVerificationEmail()),
          ),
        ],
      )),
    );
  }
}
