import 'dart:io';
import 'package:dartx/dartx.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sudokuSolver/app/module.dart';
import 'package:sudokuSolver/auth/module.dart';
import 'package:sudokuSolver/content/module.dart';

part 'cubit.freezed.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState.initial()) {}
}

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _InitialState;
  const factory ProfileState.isUploading() = _UploadingState;
  const factory ProfileState.noPermission() = _NoPermissionState;
  const factory ProfileState.success() = _SuccessState;
  const factory ProfileState.error() = _ErrorState;
}
