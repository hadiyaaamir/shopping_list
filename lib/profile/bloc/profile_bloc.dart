import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UserRepository userRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _userRepository = userRepository,
        _authenticationRepository = authenticationRepository,
        super(const ProfileState()) {
    on<ProfileFirstNameChanged>(_onFirstNameChanged);
    on<ProfileLastNameChanged>(_onLastNameChanged);
    on<ProfileDesignationChanged>(_onDesignationChanged);
    on<ProfileSubmitted>(_onSubmitted);
  }

  final UserRepository _userRepository;
  final AuthenticationRepository _authenticationRepository;

  void _onFirstNameChanged(
    ProfileFirstNameChanged event,
    Emitter<ProfileState> emit,
  ) {
    final firstName = StringInput.dirty(value: event.firstName);
    emit(
      state.copyWith(
        firstName: firstName,
        isValid: Formz.validate([firstName, state.lastName, state.username]),
      ),
    );
  }

  void _onLastNameChanged(
    ProfileLastNameChanged event,
    Emitter<ProfileState> emit,
  ) {
    final lastName = StringInput.dirty(value: event.lastName);
    emit(
      state.copyWith(
        lastName: lastName,
        isValid: Formz.validate([state.firstName, lastName, state.username]),
      ),
    );
  }

  void _onDesignationChanged(
    ProfileDesignationChanged event,
    Emitter<ProfileState> emit,
  ) {
    final username = StringInput.dirty(value: event.username);
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([state.firstName, state.lastName, username]),
      ),
    );
  }

  Future<void> _onSubmitted(
    ProfileSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        await _userRepository
            .createUser(
                userId: _authenticationRepository.currentAuthUser!.id,
                user: User(
                  firstName: state.firstName.value,
                  lastName: state.lastName.value,
                  email: _authenticationRepository.currentAuthUser!.email,
                  username: state.username.value,
                ))
            .then((value) =>
                emit(state.copyWith(status: FormzSubmissionStatus.success)));
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
