import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smusy_v2/app/module.dart';

import '../../widgets/black_button.dart';
import '../../widgets/blurry_dialog.dart';
import '../sign_in/utils.dart';
import 'cubit.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with StateWithCubit<EmailSignUpCubit, EmailSignUpState, SignUpPage> {
  @override
  EmailSignUpCubit cubit = EmailSignUpCubit();
  bool _triedSubmitting = false;
  bool _isSigningUp = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _passwordControllerConfirm = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _passwordFocusNodeConfirm = FocusNode();

  @override
  void onCubitData(EmailSignUpState state) {
    state.maybeWhen(
      isSigningUp: () => _isSigningUp = true,
      error: (error) {
        String message;
        switch (error) {
          case SignUpError.emailInUse:
            message = context.s.auth_error_emailInUse;
            break;
          case SignUpError.weakPassword:
            message = context.s.auth_error_weakPassword;
            break;
          case SignUpError.invalidEmail:
            message = context.s.auth_error_emailInvalid;
            break;
          case SignUpError.operationNotAllowed:
            message = context.s.auth_error_signUp_operationNotAllowed;
            break;
        }
        _scaffoldKey.showSimpleSnackBar(message);
        _isSigningUp = false;
      },
      success: () {
        _isSigningUp = false;
        context.showBlurryDialog(
          title: context.s.auth_signUp_successTitle,
          content: context.s.auth_signUp_successContent,
          buttonMessage: context.s.auth_signUp_successButtonMessage,
          onButtonPressed: () => context.rootNavigator..pop()..pop(),
        );
      },
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = context.mediaQuery.size.height;

    return GradientBackground(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppColors.primaryVariant(context.theme.brightness),
          title: Text(context.s.auth_signUp_title),
          leading: BackButton(),
        ),
        backgroundColor: Colors.transparent,
        body: ListView(
          children: [
            SizedBox(
              height: 0.05 * height,
            ),
            Container(
              alignment: Alignment.center,
              child: Icon(Icons.account_circle_outlined, size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                context.s.auth_signUp_infoText,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 32),
              child: _buildEmailForm(),
            ),
            SizedBox(
              height: 0.05 * height,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailForm() {
    Widget buttonChild = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(context.s.auth_signUp_register),
        Icon(Icons.arrow_forward_outlined),
      ],
    );

    // When a loading indicator is shown, we must explicitly expand the row to
    // fill the full width of the button. When there's no loading indicator, the
    // [Expanded] is used without a [Row] as it's parent, which would be
    // invalid.
    if (_isSigningUp) buttonChild = Expanded(child: buttonChild);

    return Form(
      key: _formKey,
      onChanged: () {
        // We only apply live validation after the first try to sign up.
        if (!_triedSubmitting) return;

        _formKey.currentState.validate();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SignInTextField(
            controller: _emailController,
            label: context.s.auth_signUp_email,
            icon: Icon(Icons.alternate_email),
            isEnabled: !_isSigningUp,
            focusNode: _emailFocusNode,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp('\\s'))],
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            onFieldSubmitted: (_) => _emailFocusNode.nextFocus(),
            validators: [
              FormValidator.notBlank(context.s.auth_error_emailMissing),
              FormValidator.email(context.s.auth_error_emailInvalid),
            ],
          ),
          SizedBox(height: 24),
          PasswordInputWrapper(builder: (isVisible, toggleVisibility) {
            return SignInTextField(
              controller: _passwordController,
              label: context.s.auth_signUp_password,
              icon: IconButton(
                icon: Icon(
                  isVisible ? Icons.lock_open_outlined : Icons.lock_outlined,
                ),
                onPressed: toggleVisibility,
              ),
              isEnabled: !_isSigningUp,
              focusNode: _passwordFocusNode,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              onFieldSubmitted: (_) => _passwordFocusNode.nextFocus(),
              obscureText: !isVisible,
              validators: [
                FormValidator.notBlank(context.s.auth_error_passwordMissing),
              ],
            );
          }),
          SizedBox(height: 24),
          PasswordInputWrapper(builder: (isVisible, toggleVisibility) {
            return SignInTextField(
              controller: _passwordControllerConfirm,
              label: context.s.auth_signUp_confirmPassword,
              icon: IconButton(
                icon: Icon(
                  isVisible ? Icons.lock_open_outlined : Icons.lock_outlined,
                ),
                onPressed: toggleVisibility,
              ),
              isEnabled: !_isSigningUp,
              focusNode: _passwordFocusNodeConfirm,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              onFieldSubmitted: (_) => _submitForm(),
              obscureText: !isVisible,
              validators: [
                FormValidator.notBlank(
                    context.s.auth_error_confirmPasswordMissing),
                FormValidator.noMatch(() => _passwordController.text,
                    context.s.auth_error_passwordNoMatch)
              ],
            );
          }),
          SizedBox(height: 24),
          BlackButton(
            isLoading: _isSigningUp,
            onPressed: _submitForm,
            borderRadius: InputWrapper.defaultBorderRadius,
            child: buttonChild,
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    _triedSubmitting = true;
    if (!_formKey.currentState.validate()) return;

    cubit.signUpWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );
  }
}
