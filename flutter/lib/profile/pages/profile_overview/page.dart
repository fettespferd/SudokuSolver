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

  @override
  void onCubitData(ProfileState state) {
    state.maybeWhen(
      isUploading: () {},
      noPermission: () {
        _scaffoldKey.showSimpleSnackBar(
          context.s.profile_error_noPermission,
        );
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
          ElevatedButton(
            child: Text('Ausloggen'),
            onPressed: () async {
              await services.firebaseAuth.signOut();
              await context.rootNavigator.pushReplacementNamed('/login');
            },
          ),
          ElevatedButton(
            child: Text('Einstellungen'),
            onPressed: () => context.rootNavigator.pushNamed('/settings'),
          ),
        ],
      ),
    );
  }
}
