part of 'view.dart';

class CreateProfilePage extends StatelessWidget {
  const CreateProfilePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const CreateProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Profile'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocProvider(
          create: (context) {
            return ProfileBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
              userRepository: RepositoryProvider.of<UserRepository>(context),
            );
          },
          child: const CreateProfileForm(),
        ),
      ),
    );
  }
}
