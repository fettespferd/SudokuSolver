import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smusy_v2/app/module.dart';
import 'package:smusy_v2/content/module.dart';

import '../../models.dart';

part 'cubit.freezed.dart';

// ignore: prefer_mixin
class QuestionCubit extends Cubit<QuestionState> with WidgetsBindingObserver {
  QuestionCubit(this.mode)
      : assert(mode != null),
        super(QuestionState.initial()) {
    _verifyAnswerAndLoadQuestion();
  }

  final ChallengeMode mode;

  Id<Question> _currentQuestionId;
  Question _currentQuestion;
  Question get currentQuestion => _currentQuestion;
  int _timeForCurrentQuestion; // TODO(Benjamin-Frost): Remove once added to firebase
  int get timeForCurrentQuestion =>
      _timeForCurrentQuestion; // TODO(Benjamin-Frost): Remove once added to firebase

  final _getQuestionCallable =
      services.firebaseFunctions.httpsCallable('getQuestion');
  Future<bool> _verifyAnswerAndLoadQuestion([int answerIndex]) async {
    final oldQuestionId = _currentQuestionId;
    final arguments = oldQuestionId != null
        ? {
            'currentQuestionId': oldQuestionId.value,
            'currentAnswerIndex': answerIndex,
          }
        : null;

    final response = await _getQuestionCallable.call<dynamic>(arguments);
    final responseJson =
        (response.data as Map<dynamic, dynamic>).cast<String, dynamic>();
    _currentQuestionId = Id<Question>(responseJson['nextQuestionId'] as String);
    _currentQuestion = Question.fromJson(
      (responseJson['nextQuestion'] as Map<dynamic, dynamic>)
          .cast<String, dynamic>(),
    );

    _timeForCurrentQuestion = 90;

    emit(QuestionState.questionLoaded(_currentQuestion));

    return oldQuestionId != null
        ? responseJson['isCurrentAnswerCorrect'] as bool
        : null;
  }

  Future<bool> answer(int answerIndex) async {
    assert(_currentQuestionId != null);
    return _verifyAnswerAndLoadQuestion(answerIndex);
  }

  void loadNextQuestion() =>
      emit(QuestionState.questionLoaded(_currentQuestion));

  Stream<Duration> timer() {
    final interval = Duration(milliseconds: 1000 ~/ 60);
    final stream = Stream<Duration>.periodic(
      interval,
      (x) => Duration(
          milliseconds: _timeForCurrentQuestion * 1000 - x * 1000 ~/ 60),
    );
    return stream.take(_timeForCurrentQuestion * 60).doOnDone(() => answer(-1));
  }
}

@freezed
abstract class QuestionState with _$QuestionState {
  const factory QuestionState.initial() = _InitialState;
  const factory QuestionState.questionLoaded(Question question) =
      _QuestionLoadedState;
}
