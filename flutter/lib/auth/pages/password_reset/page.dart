import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:smusy_v2/app/module.dart';

import '../../widgets/black_button.dart';
import '../../widgets/blurry_dialog.dart';
import '../sign_in/utils.dart';
import 'cubit.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage>
    with
        StateWithCubit<PasswordResetCubit, PasswordResetState,
            PasswordResetPage> {
  @override
  PasswordResetCubit cubit = PasswordResetCubit();
  bool _triedSubmitting = false;
  bool _isResetting = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  void onCubitData(PasswordResetState state) {
    state.maybeWhen(
      isResetting: () => _isResetting = true,
      error: (error) {
        String message;
        switch (error) {
          case PasswordResetError.offline:
            message = context.s.auth_error_offline;
            break;
          case PasswordResetError.emailInvalid:
            message = context.s.auth_error_emailInvalid;
            break;
          case PasswordResetError.userNotFound:
            message = context.s.auth_error_userNotFound;
            break;
        }
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(message)));
        _isResetting = false;
      },
      success: () {
        context.showBlurryDialog(
          title: context.s.auth_passwordReset_successTitle,
          content: context.s.auth_passwordReset_successContent,
          buttonMessage: context.s.auth_passwordReset_successButtonMessage,
          onButtonPressed: () => context.rootNavigator..pop()..pop(),
        );
        // We intentionally don't clear [_isResetting] to avoid flickering as
        // we're already navigating away from this page.
      },
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.primaryVariant(context.theme.brightness),
          title: Text(
            context.s.auth_passwordReset_title,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: _buildEmailForm(),
      ),
    );
  }

  Widget _buildEmailForm() {
    Widget resetButton = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(context.s.auth_passwordReset_title),
        Icon(Icons.arrow_forward_outlined),
      ],
    );
    // When a loading indicator is shown, we must explicitly expand the row to
    // fill the full width of the button. When there's no loading indicator, the
    // [Expanded] is used without a [Row] as it's parent, which would be
    // invalid.
    if (_isResetting) resetButton = Expanded(child: resetButton);

    return Form(
      key: _formKey,
      onChanged: () {
        // We only apply live validation after the first try to reset the password.
        if (!_triedSubmitting) return;
        _formKey.currentState.validate();
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 40),
              Container(
                alignment: Alignment.center,
                child: Icon(Icons.lock, size: 100),
              ),
              SizedBox(height: 40),
              Text(
                context.s.auth_passwordReset_infoText,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 25),
              _buildPasswordForm(),
              SizedBox(height: 20),
              BlackButton(
                isLoading: _isResetting,
                onPressed: _submitForm,
                borderRadius: BorderRadius.all(Radius.circular(10000)),
                child: resetButton,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordForm() {
    return SignInTextField(
      controller: _emailController,
      label: context.s.auth_signIn_email,
      icon: Icon(Icons.alternate_email),
      isEnabled: !_isResetting,
      focusNode: _emailFocusNode,
      borderRadius: BorderRadius.all(Radius.circular(10000)),
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp('\\s'))],
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.emailAddress,
      onFieldSubmitted: (_) => _submitForm(),
      validators: [
        FormValidator.notBlank(context.s.auth_error_emailMissing),
        FormValidator.email(context.s.auth_error_emailInvalid),
      ],
    );
  }

  void _submitForm() {
    _triedSubmitting = true;
    if (!_formKey.currentState.validate()) return;

    cubit.passwordReset(_emailController.text);
  }
}
