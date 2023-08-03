part of 'view.dart';

class CreateProfileForm extends StatelessWidget {
  const CreateProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        //     if (state.status.isFailure) {
        //       ScaffoldMessenger.of(context)
        //         ..hideCurrentSnackBar()
        //         ..showSnackBar(
        //           const SnackBar(content: Text('Failed to create profile')),
        //         );
        //     }
        if (state.status.isSuccess) {
          context.read<AuthenticationBloc>().add(AuthenticationUserChanged());
        }
      },
      child: const Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ErrorMessage(),
              SizedBox(height: 25),
              _FirstNameInput(),
              SizedBox(height: 20),
              _LastNameInput(),
              SizedBox(height: 20),
              _UsernameInput(),
              SizedBox(height: 40),
              _CreateProfileButton(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.status != current.status,
      builder: (context, state) {
        return state.status.isFailure
            ? ErrorText(text: state.errorMessage ?? 'Unexpected failure')
            : const SizedBox();
      },
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  const _FirstNameInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return CustomTextField(
          key: const Key('profileForm_firstNameInput_textField'),
          label: 'First Name',
          errorText: state.firstName.displayError != null
              ? 'field cannot be empty'
              : null,
          onChanged: (firstName) => context
              .read<ProfileBloc>()
              .add(ProfileFirstNameChanged(firstName)),
        );
      },
    );
  }
}

class _LastNameInput extends StatelessWidget {
  const _LastNameInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (context, state) {
        return CustomTextField(
          key: const Key('profileForm_lastNameInput_textField'),
          label: 'Last Name',
          errorText: state.lastName.displayError != null
              ? 'field cannot be empty'
              : null,
          onChanged: (lastName) =>
              context.read<ProfileBloc>().add(ProfileLastNameChanged(lastName)),
        );
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  const _UsernameInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return CustomTextField(
          key: const Key('profileForm_usernameInput_textField'),
          label: 'Username',
          errorText: state.username.displayError != null
              ? 'field cannot be empty'
              : null,
          onChanged: (username) => context
              .read<ProfileBloc>()
              .add(ProfileDesignationChanged(username)),
        );
      },
    );
  }
}

class _CreateProfileButton extends StatelessWidget {
  const _CreateProfileButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CustomProgressIndicator()
            : Button(
                key: const Key('profileForm_button'),
                onPressed: state.isValid
                    ? () {
                        context
                            .read<ProfileBloc>()
                            .add(const ProfileSubmitted());
                      }
                    : null,
                label: 'Create Profile',
              );
      },
    );
  }
}
