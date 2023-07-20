part of 'view.dart';

class ShoppingAppView extends StatefulWidget {
  const ShoppingAppView({super.key});

  @override
  State<ShoppingAppView> createState() => _ShoppingAppViewState();
}

class _ShoppingAppViewState extends State<ShoppingAppView> {
  @override
  Widget build(BuildContext context) {
    GoRouter router = AppRouter.router;

    return MaterialApp.router(
      title: 'Flutter Login App',
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kSeedColor),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.unverified:
                router.go('/verifyEmail');

              case AuthenticationStatus.authenticated:
                router.go(
                  state.profileCreated ? '/shoppingLists' : '/createProfile',
                );

              case AuthenticationStatus.unauthenticated:
                router.go('/login');

              case AuthenticationStatus.unknown:
                break;
            }
          },
          child: child,
        );
      },
    );
  }
}
