//
//  MediaItemRow.swift
//  MediaLibraryTesting
//
//  Created by Ben Gottlieb on 10/18/21.
//

import SwiftUI
import MediaPlayer

struct MediaItemRow: View {
	let mediaItem: MPMediaItem
	var body: some View {
		NavigationLink(destination: MediaItemDetails(mediaItem: mediaItem)) {
			VStack() {
				HStack() {
					MediaItemThumbnail(mediaItem: mediaItem)
					VStack(alignment: .leading) {
						Text(mediaItem.title ?? "Untitled")
						Text(mediaItem.artist ?? "Unknown Artist")
					}
					.lineLimit(1)
					Spacer()
					if mediaItem.playbackDuration > 0 {
						Text(mediaItem.playbackDuration.durationString())
					}
				}
				Rectangle()
					.fill(Color.gray)
					.frame(height: 0.5)
			}
		}
	}
}

