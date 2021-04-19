# Menu vs. Alert

Demo project for demonstrating an issue that can occur when showing an `NSAlert` modally/synchronously while a `NSMenu` is open.
In that case, a situation might arise where the menu covers all of the alert, making neither respond. The result is that the app is pretty much locked up at that point without any way to close either the menu or the alert.

The fix/workaround I implemented is to track the active menu using `NSMenu.didBeginTrackingNotification` and `NSMenu.didEndTrackingNotification`. Then, when it's time to show the alert I cancel tracking on the active menu (if any).
The best way to deal with this issue is to not run the alert modally/synchronously in the first place. Unfortunately, there are situations where this is not possible, hence this project.
