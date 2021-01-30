import 'services.dart';

export 'dart:ui' show Color;

export 'package:basics/basics.dart';
export 'package:black_hole_flutter/black_hole_flutter.dart';
export 'package:bloc/bloc.dart';
export 'package:collection/collection.dart';
export 'package:flutter/foundation.dart' hide binarySearch, mergeSort;
export 'package:freezed_annotation/freezed_annotation.dart';
export 'package:meta/meta.dart';
export 'package:time_machine/time_machine.dart' show Instant, LocalDate, Period;
export 'package:time_machine/time_machine_text_patterns.dart';

export 'app.dart';
export 'brand/colors.dart';
export 'brand/theme.dart';
export 'brand/widgets.dart';
export 'cubit.dart';
export 'entity.dart';
export 'form.dart';
export 'logger.dart' show logger;
export 'models.dart';
export 'routing.dart' show appSchemeUrl, webUrl, sudokuSolverWebUrl;
export 'services.dart' hide initServices;
export 'utils.dart';
export 'widgets/form.dart';
export 'widgets/text.dart';

Future<void> initApp() => initServices();
