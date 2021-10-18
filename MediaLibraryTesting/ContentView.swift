//
//  ContentView.swift
//  MediaLibraryTesting
//
//  Created by Ben Gottlieb on 10/14/21.
//

import SwiftUI
import Suite

struct ContentView: View {
	@ObservedObject var library = MediaLibrary.instance
	
	var body: some View {
		NavigationView() {
			if !library.hasAccess {
				Button(action: { library.authorize() }) {
					Text("Request Access")
						.padding()
				}
			} else {
				ScrollView() {
					LazyVStack() {
						ForEach(library.mediaItems) { item in
							MediaItemRow(mediaItem: item)
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
