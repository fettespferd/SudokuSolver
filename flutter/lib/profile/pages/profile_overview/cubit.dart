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
  ProfileCubit() : super(ProfileState.initial()) {
    _checkState();
  }

  Future<void> upload(File uploadFile, DocumentType type) async {
    emit(ProfileState.isUploading());
    await _getDocumentStorageRef(services.auth.userId, type)
        .putFile(uploadFile);
    await _checkState();
  }

  Future<void> delete(DocumentType type) async {
    await User.storageBase
        .child(services.auth.userId.value)
        .child(type.storageName)
        .delete();
    await _checkState();
  }

  Future<void> download(DocumentType type) async {
    final ref = _getDocumentStorageRef(services.auth.userId, type);
    String storagePath;
    if (Platform.isAndroid) {
      final externalDir =
          await getExternalStorageDirectories(type: StorageDirectory.downloads);
      storagePath = externalDir[0].path;
    } else if (Platform.isIOS) {
      final externalDir = getApplicationDocumentsDirectory();
      storagePath = externalDir.toString();
    } else {
      emit(ProfileState.error());
    }
    var downloadPath = p.join(storagePath, '${type.storageName}.pdf');
    var tempFile = File(downloadPath);
    var index = 0;
    if (await Permission.storage.request().isGranted) {
      while (tempFile.existsSync()) {
        index++;
        downloadPath = p.join(downloadPath, '${type.storageName}$index.pdf');
        tempFile = File(downloadPath);
      }
      await tempFile.create();
      await ref.writeToFile(tempFile);
      //open file
      await OpenFile.open(tempFile.path);
    } else {
      emit(ProfileState.noPermission());
    }
  }

  Future<void> _checkState() async {
    final resultList = await _getStorageRefList(services.auth.userId);
    final resultSet = resultList.items
        .map((e) => e.name)
        .map((e) => DocumentType.values
            .firstOrNullWhere((element) => element.storageName == e))
        .whereNotNull()
        .toSet();
    emit(ProfileState.success(resultSet));
  }

  Future<ListResult> _getStorageRefList(Id<User> authorId) =>
      User.storageBase.child(authorId.value).listAll();

  Reference _getDocumentStorageRef(Id<User> authorId, DocumentType type) =>
      User.storageBase.child(authorId.value).child(type.storageName);
}

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _InitialState;
  const factory ProfileState.isUploading() = _UploadingState;
  const factory ProfileState.noPermission() = _NoPermissionState;
  const factory ProfileState.success(Set<DocumentType> resultSet) =
      _SuccessState;
  const factory ProfileState.error() = _ErrorState;
}

enum DocumentType {
  cv,
  certificate,
  workshop,
}

extension FancyDocumentType on DocumentType {
  String get storageName {
    return {
      DocumentType.cv: 'cv',
      DocumentType.certificate: 'certificate',
      DocumentType.workshop: 'workshop'
    }[this];
  }
}
