import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:sudokuSolver/app/module.dart';

part 'cubit.freezed.dart';

// ignore: prefer_mixin
class CameraCubit extends Cubit<CameraState> with WidgetsBindingObserver {
  CameraCubit() : super(CameraState.initial()) {
    _loadCameras();
  }

  List<CameraDescription> _cameras;
  List<CameraDescription> get cameras => _cameras;
  CameraController _controller;
  CameraController get controller => _controller;
  bool get _controllerInitialized =>
      controller != null && controller.value.isInitialized;

  Future<void> _loadCameras() async {
    try {
      _cameras = await availableCameras();
      emit(CameraState.camerasLoaded(cameras));

      if (cameras.isNotEmpty) {
        final camera = cameras.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.back) ??
            cameras.first;
        await _onCameraSelected(camera);
      }
    } on CameraException catch (e) {
      emit(CameraState.error(e));
    }
  }

  bool get canToggleCameras =>
      cameras != null && cameras.length > 1 && _controllerInitialized;
  void toggleCameras() {
    if (!canToggleCameras) return;

    final currentIndex = cameras.indexOf(controller.description);
    _onCameraSelected(cameras[(currentIndex + 1) % cameras.length]);
  }

  Future<void> _onCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) await controller.dispose();

    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.veryHigh,
      enableAudio: false,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      emit(CameraState.controllerUpdate(controller.value));
      if (controller.value.hasError) {
        emit(CameraState.error(
          CameraException('unknown', controller.value.errorDescription),
        ));
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      emit(CameraState.error(e));
    }

    emit(CameraState.controllerUpdate(controller.value));
  }

  bool get canTakePicture =>
      _controllerInitialized && !controller.value.isTakingPicture;
  Future<String> takePicture() async {
    if (!canTakePicture) return null;

    XFile path;
    try {
      path = await controller.takePicture();
    } on CameraException catch (e) {
      emit(CameraState.error(e));
      return null;
    }
    return path.path;
  }

  bool selectGradient() => true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (controller == null || !controller.value.isInitialized) {
      // App state changed before we got the chance to initialize.
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed && controller != null) {
      _onCameraSelected(controller.description);
    }
  }
}

@freezed
abstract class CameraState with _$CameraState {
  const factory CameraState.initial() = _InitialState;
  const factory CameraState.camerasLoaded(List<CameraDescription> cameras) =
      _CamerasLoadedState;
  const factory CameraState.controllerUpdate(CameraValue value) =
      _ControllerUpdateState;
  const factory CameraState.error(CameraException e) = _ErrorState;
}
