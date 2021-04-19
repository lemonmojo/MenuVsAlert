import Cocoa

public extension NSMenu {
	private struct _ActiveMenuStorage {
		static var isTrackingActiveMenu = false
		
		weak static var activeMenu: NSMenu?
	}
	
	/**
	Tracking of the active menu requires setting up an observer.
	So before you can access the active menu, call `isTrackingActiveMenu = true`.
	When you're done monitoring the active menu, call `isTrackingActiveMenu = false` to remove the observer.
	*/
	static var activeMenu: NSMenu? {
		_ActiveMenuStorage.activeMenu
	}
	
	static var isTrackingActiveMenu: Bool {
		get {
			_ActiveMenuStorage.isTrackingActiveMenu
		}
		set {
			if newValue && !_ActiveMenuStorage.isTrackingActiveMenu {
				NotificationCenter.default.addObserver(NSMenu.self,
													   selector: #selector(menuDidBeginTracking(_:)),
													   name: NSMenu.didBeginTrackingNotification,
													   object: nil)
				
				NotificationCenter.default.addObserver(NSMenu.self,
													   selector: #selector(menuDidEndTracking(_:)),
													   name: NSMenu.didEndTrackingNotification,
													   object: nil)
			} else if !newValue && _ActiveMenuStorage.isTrackingActiveMenu {
				NotificationCenter.default.removeObserver(NSMenu.self,
														  name: NSMenu.didBeginTrackingNotification,
														  object: nil)
				
				NotificationCenter.default.removeObserver(NSMenu.self,
														  name: NSMenu.didEndTrackingNotification,
														  object: nil)
			}
			
			_ActiveMenuStorage.isTrackingActiveMenu = newValue
		}
	}
	
	@objc static func menuDidBeginTracking(_ notification: Notification) {
		guard let menu = notification.object as? NSMenu else {
			return
		}
		
		_ActiveMenuStorage.activeMenu = menu
	}
	
	@objc static func menuDidEndTracking(_ notification: Notification) {
		guard let menu = notification.object as? NSMenu else {
			return
		}
		
		guard menu == _ActiveMenuStorage.activeMenu else {
			return
		}
		
		_ActiveMenuStorage.activeMenu = nil
	}
}
