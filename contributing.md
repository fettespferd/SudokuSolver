# Contributing

## Local Setup

- install [<img src="https://git-scm.com/favicon.ico" width="16" height="16"> Git](https://git-scm.com/downloads)
- install [<img src="https://github.githubassets.com/pinned-octocat.svg" width="16" height="16"> GitHub Desktop](https://desktop.github.com)
- install [<img src="https://code.visualstudio.com/favicon.ico" width="16" height="16"> Visual Studio Code](https://code.visualstudio.com) (VS Code)
- install [<img src="https://flutter.dev/images/favicon.png" width="16" height="16"> Flutter](https://flutter.dev/docs/get-started/install)
- clone this repository by running `git clone https://github.com/smusy-GmbH/smusy_v2.git` in your terminal
- open the workspace `./smusy.code-workspace` in VS Code
  - You'll probably see notifications asking you to install some extensions and get packages. Please confirm these two actions.
- For running the app on <kbd>Android</kbd>: Download the `google-services.json` from [Firebase](https://console.firebase.google.com/u/0/project/smusy-dev/settings/general/android:app.smusy.dev) and store it in `./flutter/android/app/src/debug`.
- For running the app on <kbd>iOS</kbd>: Download the `GoogleService-Info.plist` from [Firebase](https://console.firebase.google.com/u/0/project/smusy-dev/settings/general/ios:app.smusy.dev) and store it in `./flutter/ios/config/Debug`.
- open a terminal in VS Code in the flutter directory
  - run `flutter pub run build_runner watch --delete-conflicting-outputs`

You should now be able to run the app by opening the debug panel on the left and pressing the green triangle at the top (or using the shortcut `F5`).

## Selecting an issue

Visit the [issues page](https://github.com/smusy-GmbH/smusy_v2/issues) and look for an interesting problem you want to solve.

- If you're new to this project, we recommend issues tagged with [<kbd>good first issue</kbd>](https://github.com/smusy-GmbH/smusy_v2/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22+no%3Aassignee).
- We use GitHub projects to plan our next steps and set priorities: [smusy_v2/projects](https://github.com/smusy-GmbH/smusy_v2/projects).

Once you have selected an issue to work on, assign yourself to that issue so we don't end up with two people doing the same thing^^

Create a new branch `issue/<id>-<lowercase-issue-title-with-dashes>` (e.g., `issue/67-contribution-guide`) and switch to that branch.

## Working on stuff

Work on your code. Repeat:

- Implement your changes. Make sure your code adheres to our [code style](Supporting%20Documents/code%20style.md).
- Run the app.
- Commit your changes.
- Push to the repo (or your fork).

## It's working!

When you're done, file a pull request. We will take a look at your code and once all checks pass, your code can get merged 🏖

---

**Next read**: [Getting to know the smusy. app architecture](Supporting%20Documents/architecture.md)
