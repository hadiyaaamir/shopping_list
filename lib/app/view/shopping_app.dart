part of 'view.dart';

class ShoppingApp extends StatefulWidget {
  const ShoppingApp({super.key});

  @override
  State<ShoppingApp> createState() => _ShoppingAppState();
}

class _ShoppingAppState extends State<ShoppingApp> {
  late final AuthenticationRepository _authenticationRepository;
  late final UserRepository _userRepository;
  late final ShoppingListRepository _shoppingListRepository;

  @override
  void initState() {
    super.initState();
    _authenticationRepository = AuthenticationRepositoryFirebase();
    _userRepository = UserRepositoryFirebase();
    _shoppingListRepository = ShoppingListRepositoryFirebase();
  }

  @override
  void dispose() {
    _authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _shoppingListRepository),
      ],
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: _authenticationRepository,
          userRepository: _userRepository,
        ),
        child: const ShoppingAppView(),
      ),
    );
  }
}
