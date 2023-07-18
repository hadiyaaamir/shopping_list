part of 'view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ProfilePage());
  }

  getUser() {}

  @override
  Widget build(BuildContext context) {
    final authUser = context.select(
      (AuthenticationBloc bloc) => bloc.state.user,
    );

    final userFuture = context
        .read<UserRepository>()
        .getUser(userId: authUser.id, email: authUser.email);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    children: [
                      FutureBuilder<User>(
                        future: userFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            final user = snapshot.data!;
                            return Column(
                              children: [
                                ProfileInformation(
                                  title: 'Name',
                                  information:
                                      '${user.firstName} ${user.lastName}',
                                ),
                                ProfileInformation(
                                    title: 'Email', information: user.email),
                                ProfileInformation(
                                  title: 'Username',
                                  information: user.username,
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return const Text('Error loading user data');
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Button(
                onPressed: () {
                  context
                      .read<AuthenticationBloc>()
                      .add(AuthenticationLogoutRequested());
                },
                label: 'Log Out'),
          ],
        ),
      ),
    );
  }
}

class ProfileInformation extends StatelessWidget {
  const ProfileInformation({
    super.key,
    required this.title,
    required this.information,
  });

  final String title;
  final String information;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Wrap(
          children: [
            Text(
              '$title: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(information)
          ],
        ),
      ),
    );
  }
}
