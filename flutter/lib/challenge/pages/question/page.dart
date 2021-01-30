import 'package:flutter/material.dart';
import 'package:sudokuSolver/app/module.dart';
import 'package:sudokuSolver/challenge/models.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'cubit.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage(this.mode) : assert(mode != null);

  final ChallengeMode mode;

  @override
  _QuestionPageState createState() => _QuestionPageState(mode);
}

class _QuestionPageState extends State<QuestionPage>
    with StateWithCubit<QuestionCubit, QuestionState, QuestionPage> {
  _QuestionPageState(ChallengeMode mode)
      : assert(mode != null),
        cubit = QuestionCubit(mode);

  @override
  final QuestionCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(32),
        child: cubit.currentQuestion != null
            ? _buildQuestionContent(context)
            : Center(child: CircularProgressIndicator()),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF643FB2), Color(0xFF3532C2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  SafeArea _buildQuestionContent(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          StreamBuilder<Duration>(
            stream: cubit.timer(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final twoDigitSeconds = snapshot.data.inSeconds
                    .remainder(60)
                    .toString()
                    .padLeft(2, '0');

                return percentIndicator(
                  context: context,
                  percent: snapshot.data.inMilliseconds /
                      (cubit.timeForCurrentQuestion * 1000),
                  content: Text('${snapshot.data.inMinutes}:$twoDigitSeconds'),
                );
              } else {
                return percentIndicator(
                  context: context,
                  content: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
          Spacer(),
          Text(
            cubit.currentQuestion.text.getValue(context),
            style: context.textTheme.headline5,
          ),
          Spacer(),
          for (var i = 0; i < cubit.currentQuestion.answers.length; ++i)
            _buildAnswerButton(
                context, i, cubit.currentQuestion.answers[i].getValue(context)),
          _buildAnswerButton(
              context, null, context.s.challenge_quickplay_noCorrectAnswer)
        ],
      ),
    );
  }

  LinearPercentIndicator percentIndicator({
    BuildContext context,
    Widget content,
    double percent = 1,
  }) {
    return LinearPercentIndicator(
      center: content,
      lineHeight: 30,
      percent: percent,
      backgroundColor: Colors.white.withOpacity(0.5),
      progressColor: context.theme.primaryColor,
    );
  }

  Widget _buildAnswerButton(
    BuildContext context,
    int answerIndex,
    String answerText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RaisedButton(
        onPressed: () => cubit.answer(answerIndex),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            answerText,
            style: context.textTheme.headline6,
          ),
        ),
        color: Colors.black.withOpacity(0.25),
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
