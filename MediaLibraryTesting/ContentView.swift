//
//  ContentView.swift
//  MediaLibraryTesting
//
//  Created by Ben Gottlieb on 10/14/21.
//

import SwiftUI
import Suite
import MediaPlayer

struct ContentView: View {
	@ObservedObject var library = MediaLibrary.instance
	@State var showLocalOnly = false
	@State var showUnprotectedOnly = false
	
	var mediaItems: [MPMediaItem] {
		library.mediaItems.filter {
			if showLocalOnly, $0.assetURL == nil { return false }
			if showUnprotectedOnly, $0.hasProtectedAsset { return false }
			return true
		}
	}
	
	var body: some View {
		NavigationView() {
			if !library.hasAccess {
				Button(action: { library.authorize() }) {
					Text("Request Access")
						.padding()
				}
			} else {
				VStack() {
					HStack() {
						Toggle("Downloaded", isOn: $showLocalOnly)
						Toggle("Unprotected", isOn: $showUnprotectedOnly)
					}
					.padding()
					ScrollView() {
						LazyVStack() {
							ForEach(mediaItems) { item in
								MediaItemRow(mediaItem: item)
							}
						}
					}
				}
				.navigationTitle("All Media")
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
