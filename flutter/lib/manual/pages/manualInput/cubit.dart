import 'package:sudokuSolver/app/module.dart';

part 'cubit.freezed.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState.initial());
}

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _InitialState;
  const factory ProfileState.isUploading() = _UploadingState;
  const factory ProfileState.noPermission() = _NoPermissionState;
  const factory ProfileState.success() = _SuccessState;
  const factory ProfileState.error() = _ErrorState;
}
