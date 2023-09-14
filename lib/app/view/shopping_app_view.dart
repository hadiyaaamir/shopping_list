part of 'view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class ShoppingAppView extends StatefulWidget {
  const ShoppingAppView({super.key});

  @override
  State<ShoppingAppView> createState() => _ShoppingAppViewState();
}

class _ShoppingAppViewState extends State<ShoppingAppView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login App',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kSeedColor),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.unverified:
                navigatorKey.currentState?.pushAndRemoveUntil(
                  VerifyEmailPage.route(),
                  (route) => false,
                );

              case AuthenticationStatus.authenticated:
                navigatorKey.currentState?.pushAndRemoveUntil(
                  state.profileCreated
                      ? ParentListPage.route()
                      : CreateProfilePage.route(),
                  (route) => false,
                );

              case AuthenticationStatus.unauthenticated:
                navigatorKey.currentState?.pushAndRemoveUntil(
                  LoginPage.route(),
                  (route) => false,
                );

              case AuthenticationStatus.unknown:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
