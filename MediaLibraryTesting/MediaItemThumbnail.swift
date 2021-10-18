//
//  MediaItemThumbnail.swift
//  MediaLibraryTesting
//
//  Created by Ben Gottlieb on 10/18/21.
//

import SwiftUI
import MediaPlayer

struct MediaItemThumbnail: View {
	let image: UIImage?
	let size: CGSize
	
	init(mediaItem: MPMediaItem, size: CGSize = .init(width: 60, height: 60)) {
		self.size = size
		if let art = mediaItem.artwork?.image(at: size) {
			image = art
		} else {
			image = nil
		}
	}
	
	var body: some View {
		HStack(spacing: 0) {
			if let image = image {
				Image(uiImage: image)
					.resizable()
					.aspectRatio(contentMode: .fit)
			}
			Spacer()
		}
		.frame(width: size.width)
	}
}
