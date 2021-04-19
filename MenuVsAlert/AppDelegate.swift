import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
	@IBOutlet var window: NSWindow!
	@IBOutlet weak var textField: NSTextField!
	@IBOutlet weak var contextMenu: NSMenu!
	
	func applicationDidFinishLaunching(_ notification: Notification) {
		textField.menu = contextMenu
	}
	
	func applicationWillTerminate(_ notification: Notification) {
		NSMenu.isTrackingActiveMenu = false
	}
	
	func menuWillOpen(_ menu: NSMenu) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
			self?.showAlertAsModalSheet()
		}
	}
	
	@IBAction func checkBoxActivateFix_action(_ sender: NSButton) {
		let shouldActivate = sender.state == .on
		
		NSMenu.isTrackingActiveMenu = shouldActivate
	}
	
	func showAlertAsModalSheet() {
		let alert = NSAlert()
		alert.messageText = "Can you press me?"
		alert.addButton(withTitle: "Guess not…")
		
		var shouldEndSheet = false
		
		NSMenu.activeMenu?.cancelTrackingWithoutAnimation()
		
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
