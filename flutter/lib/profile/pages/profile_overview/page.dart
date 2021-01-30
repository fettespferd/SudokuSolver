import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sudokuSolver/app/module.dart';

import 'cubit.dart';

class ProfileOverviewPage extends StatefulWidget {
  @override
  _ProfileOverviewPageState createState() => _ProfileOverviewPageState();
}

class _ProfileOverviewPageState extends State<ProfileOverviewPage>
    with StateWithCubit<ProfileCubit, ProfileState, ProfileOverviewPage> {
  @override
  ProfileCubit cubit = ProfileCubit();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isUploading = false;
  Set<DocumentType> documentTypeSet;

  @override
  void onCubitData(ProfileState state) {
    state.maybeWhen(
      isUploading: () => _isUploading = true,
      noPermission: () {
        _scaffoldKey.showSimpleSnackBar(
          context.s.profile_error_noPermission,
        );
      },
      success: (resultSet) {
        _isUploading = false;
        documentTypeSet = resultSet;
      },
      error: () {
        _scaffoldKey.showSimpleSnackBar(
          context.s.general_error_unknown,
        );
      },
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DocumentContainer(
                type: DocumentType.cv,
                documentExists: documentTypeSet?.contains(DocumentType.cv),
                isUploading: _isUploading,
                cubit: cubit,
              ),
              SizedBox(width: 20),
              DocumentContainer(
                type: DocumentType.certificate,
                documentExists:
                    documentTypeSet?.contains(DocumentType.certificate),
                isUploading: _isUploading,
                cubit: cubit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DocumentContainer extends StatelessWidget {
  const DocumentContainer({
    @required this.type,
    @required this.documentExists,
    @required this.isUploading,
    @required this.cubit,
  })  : assert(isUploading != null),
        assert(cubit != null),
        assert(type != null);

  final DocumentType type;
  final bool documentExists;
  final bool isUploading;
  final ProfileCubit cubit;

  List<String> get allowedDocExtensions => ['pdf'];

  String getLocalizedStorageName(DocumentType type, BuildContext context) {
    switch (type.storageName) {
      case 'cv':
        return context.s.profile_document_cv;
      case 'certficate':
        return context.s.profile_document_certificate;
      case 'workshop':
        return context.s.profile_document_workshop;
      default:
        return context.s.profile_document_certificate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          getLocalizedStorageName(type, context),
          style:
              context.textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () async {
            if (documentExists) {
              await cubit.download(type);
            } else {
              final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: allowedDocExtensions);
              if (result != null) {
                final uploadFile = File(result.files.single.path);
                await cubit.upload(uploadFile, type);
              }
            }
          },
          onLongPress: () async {
            final result = await context.showDeletionDialog();
            if (result) await cubit.delete(type);
          },
          child: BoxWidget(
            documentExists: documentExists,
            isUploading: isUploading,
          ),
        ),
      ],
    );
  }
}

class BoxWidget extends StatelessWidget {
  const BoxWidget({
    @required this.documentExists,
    @required this.isUploading,
  }) : assert(isUploading != null);

  final bool documentExists;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    if (isUploading || documentExists == null) {
      return CircularProgressIndicator();
    } else {
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: documentExists ? Colors.green : Colors.red,
        ),
        child: Center(
          child: documentExists
              ? Icon(Icons.download_sharp)
              : Text(
                  context.s.profile_document_upload,
                  style: context.textTheme.bodyText2.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
        ),
      );
    }
  }
}
