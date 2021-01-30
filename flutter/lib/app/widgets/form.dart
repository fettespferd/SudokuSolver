import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

extension FormDialogs on BuildContext {
  Future<bool> showDiscardChangesDialog() async {
    final result = await showDialog<bool>(
      context: this,
      builder: (context) {
        return AlertDialog(
          title: Text(context.s.app_form_discardChanges),
          content: Text(context.s.app_form_discardChanges_message),
          actions: <Widget>[
            FlatButton(
              onPressed: () => context.navigator.pop(false),
              child: Text(context.s.app_form_discardChanges_action_keepEditing),
            ),
            FlatButton(
              onPressed: () => context.navigator.pop(true),
              child: Text(context.s.app_form_discardChanges_action_discard),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Future<bool> showDeletionDialog() async {
    final result = await showDialog<bool>(
      context: this,
      builder: (context) {
        return AlertDialog(
          title: Text(context.s.app_form_delete),
          content: Text(context.s.app_form_delete_message),
          actions: <Widget>[
            FlatButton(
              onPressed: () => context.navigator.pop(false),
              child: Text(context.s.app_form_delete_action_cancel),
            ),
            FlatButton(
              onPressed: () => context.navigator.pop(true),
              child: Text(context.s.app_form_delete_action_delete),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
