import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
	@IBOutlet var window: NSWindow!
	
	func menuWillOpen(_ menu: NSMenu) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
			self?.showAlertAsModalSheet()
		}
	}
	
	func showAlertAsModalSheet() {
		let alert = NSAlert()
		alert.messageText = "Can you press me?"
		alert.addButton(withTitle: "Guess not…")
		
		var shouldEndSheet = false
		
		// Commenting the following line in makes it work but what should I do if I don't know if a menu is currently open and which one it is???
		// The code that opens the modal sheet may be called from all kinds of locations in the app, and there are other context menus which may be open.
		// I can't figure out a way to generically detect if any menu is open and close it before showing the alert.
//		self.window.menu?.cancelTrackingWithoutAnimation()
		
		alert.beginSheetModal(for: self.window) { (response) in
			shouldEndSheet = true
		}
		
		let modalSession = NSApp.beginModalSession(for: alert.window)
		
		while !shouldEndSheet {
			if NSApp.runModalSession(modalSession) != .continue {
				break
			}
			
			RunLoop.current.run(mode: .default, before: .distantFuture)
		}
		
		NSApp.endModalSession(modalSession)
		self.window.endSheet(alert.window)
	}
}
