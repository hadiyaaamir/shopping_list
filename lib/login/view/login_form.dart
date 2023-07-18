part of 'view.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ErrorMessage(),
            SizedBox(height: 25),
            _EmailInput(),
            SizedBox(height: 20),
            _PasswordInput(),
            SizedBox(height: 40),
            _LoginButton(),
            SizedBox(height: 20),
            _SignupLink(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.status != current.status,
      builder: (context, state) {
        return state.status.isFailure
            ? ErrorText(text: state.errorMessage ?? 'Authentication Failure')
            : const SizedBox();
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return CustomTextField(
          key: const Key('loginForm_emailInput_textField'),
          label: 'Email',
          errorText: state.email.displayError != null ? 'invalid email' : null,
          onChanged: (email) =>
              context.read<LoginBloc>().add(LoginEmailChanged(email)),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return CustomTextField(
          key: const Key('loginForm_passwordInput_textField'),
          label: 'Password',
          obsecureText: true,
          errorText: state.password.displayError != null
              ? 'password must be atleast 8 characters long'
              : null,
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : Button(
                key: const Key('loginForm_button'),
                onPressed: state.isValid
                    ? () {
                        context.read<LoginBloc>().add(const LoginSubmitted());
                      }
                    : null,
                label: 'Log In',
              );
      },
    );
  }
}

class _SignupLink extends StatelessWidget {
  const _SignupLink();

  @override
  Widget build(BuildContext context) {
    return LinkText(
      text: 'Don\'t have an account? ',
      boldText: 'Sign Up',
      onTap: () => Navigator.pushReplacement(context, SignupPage.route()),
    );
  }
}
