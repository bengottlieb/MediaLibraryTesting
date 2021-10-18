//
//  MediaLibrary.swift
//  MediaLibraryTesting
//
//  Created by Ben Gottlieb on 10/14/21.
//

import Foundation
import MediaPlayer

class MediaLibrary: ObservableObject {
	static let instance = MediaLibrary()
	
	var hasAccess = false { willSet { self.objectWillChange.send(); updateMedia() }}
	lazy var library = MPMediaLibrary.default()
	
	var mediaItems: [MPMediaItem] = []
	
	init() {
		hasAccess = MPMediaLibrary.authorizationStatus() == .authorized
		if hasAccess { updateMedia() }
	}
	
	func authorize() {
		MPMediaLibrary.requestAuthorization { status in
			DispatchQueue.main.async {
				self.hasAccess = status == .authorized
			}
		}
	}
	
	func updateMedia() {
		guard hasAccess else { return }
		
		Task {
			if let items = MPMediaQuery.songs().items {
				DispatchQueue.main.async {
					self.objectWillChange.send()
					self.mediaItems = items
				}
			}
		}
	}
}

extension MPMediaItem: Identifiable {
	public var id: UInt64 { persistentID }
}
