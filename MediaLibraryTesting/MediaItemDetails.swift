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
				Task() {
					do {
						if await !mediaItem.validateLocality() {
							print("Non-local item")
							return
						}
						let url = try await mediaItem.export()
						print(url)
					} catch {
						print("Error while exporting: \(error)")
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
	
	func validateLocality() async -> Bool {
		if self.assetURL != nil { return true }
		if self.hasProtectedAsset {
			print("Protected item")
			return false
		}
		
		let player = MPMusicPlayerController.systemMusicPlayer
		player.setQueue(with: MPMediaItemCollection(items: [self]))
		
		do {
			try await player.prepareToPlay()
		} catch {
			print("Failed to prepare to play: \(error)")
			return false
		}
		return self.assetURL != nil
	}
	
	func export() async throws -> URL {
		guard let assetURL = self.assetURL else {
			throw ExportError.noAssetURL
		}
		let asset = AVURLAsset(url: assetURL)
		guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
			throw ExportError.unableToCreateExporter
		}
		
		let fileURL = URL.documents
			.appendingPathComponent(title ?? "\(id)")
			.appendingPathExtension("m4a")
		
		exporter.outputURL = fileURL
		exporter.outputFileType = .m4a
		
		await exporter.export()
		if exporter.status == .completed {
			return fileURL
		} else {
			throw exporter.error ?? ExportError.unknownError
		}
	}
	
}
