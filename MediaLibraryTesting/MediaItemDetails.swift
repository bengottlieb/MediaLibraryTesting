//
//  MediaItemDetails.swift
//  MediaLibraryTesting
//
//  Created by Ben Gottlieb on 10/18/21.
//

import SwiftUI
import MediaPlayer

struct MediaItemDetails: View {
	let mediaItem: MPMediaItem
	var body: some View {
		VStack() {
			GeometryReader() { geo in
				MediaItemThumbnail(mediaItem: mediaItem, size: geo.size)
			}
			.aspectRatio(contentMode: .fit)
			
			Button("Copy \(mediaItem.title ?? "This Item")") {
				mediaItem.export { result in
					switch result {
					case .success(let url):
						print("Exported to \(url)")
						
					case .failure(let error):
						print("Failed to export: \(error)")
					}
				}
			}
			Spacer()
		}
		.navigationTitle(mediaItem.title ?? "")
	}
}

extension MPMediaItem {
	enum ExportError: Error { case noAssetURL, unableToCreateExporter, unknownError }
	func export(completion: @escaping (Result<URL, Error>) -> ()) {
		guard let assetURL = self.assetURL else {
			completion(.failure(ExportError.noAssetURL))
			return
		}
		let asset = AVURLAsset(url: assetURL)
		guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
			completion(.failure(ExportError.unableToCreateExporter))
			return
		}
		
		let fileURL = URL.documents
			.appendingPathComponent(title ?? "\(id)")
			.appendingPathExtension("m4a")
		
		exporter.outputURL = fileURL
		exporter.outputFileType = .mp4
		
		exporter.exportAsynchronously {
			if exporter.status == .completed {
				completion(.success(fileURL))
			} else {
				completion(.failure(exporter.error ?? ExportError.unknownError))
			}
		}
	}
	
}
