//
//  ShazamListener.swift
//  RoyalShazamListener
//
//  Created by Eduardo Andres Rodriguez Parejo on 2/22/22.
//

import AVFAudio
import Foundation
import ShazamKit
import UIKit

typealias ShazamMatchingCallback = ((ShazamMetadata?) -> Void)?

enum ShazamListenerType {
    case music
    case custom(_ catalog: SHCustomCatalog)
}

final class ShazamListener: NSObject {
    private let audioEngine = AVAudioEngine()
    
    private var session: SHSession?
    private var type: ShazamListenerType?
    private var matchingCallback: ShazamMatchingCallback?

    func setup(type: ShazamListenerType, callback: ShazamMatchingCallback) throws {
        self.matchingCallback = callback
        switch type {
        case .music:
            session = SHSession()
        case .custom(let catalog):
            session = SHSession(catalog: catalog)
        }
        self.type = type
        session?.delegate = self
    }
    
    func listen() throws {
        stop()
        
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: audioEngine.inputNode.outputFormat(forBus: 0).sampleRate,
                                        channels: 1)
        audioEngine.inputNode.installTap(onBus: 0,
                                         bufferSize: 2048,
                                         format: audioFormat) { [weak session] buffer, audioTime in
            session?.matchStreamingBuffer(buffer, at: audioTime)
        }
        
        try AVAudioSession.sharedInstance().setCategory(.record)
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] result in
            guard let strongSelf = self, result else {
                return
            }
            strongSelf.prepare()
            try? strongSelf.start()
        }
    }
    
    func start() throws {
        try? audioEngine.start()
    }
    
    func prepare() {
        audioEngine.prepare()
    }
    
    func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    func pause() {
        audioEngine.pause()
    }
    
    func reset() {
        audioEngine.reset()
    }
}

extension ShazamListener: SHSessionDelegate {
    func session(_ session: SHSession, didFind match: SHMatch) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self, let callback = strongSelf.matchingCallback, let type = strongSelf.type, let itemMatched = match.mediaItems.first else {
                return
            }
            
            switch type {
            case .music:
                strongSelf.handleMedia(item: itemMatched, callback: callback)
            case .custom:
                strongSelf.handleCustomCatalog(item: itemMatched, callback: callback)
            }
        }
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        print(error.debugDescription)
    }
    
    private func handleCustomCatalog(item: SHMatchedMediaItem, callback: ShazamMatchingCallback) {
        let metadata = ShazamCustomMetadata.convertToMetaData(item: item)
        callback?(metadata)
        if metadata.state == .stop || metadata.state == .invalid {
            stop()
        }
    }
    
    private func handleMedia(item: SHMatchedMediaItem, callback: ShazamMatchingCallback) {
        callback?(ShazamMediaMetadata(title: item.title, subtitle: item.subtitle, artistName: item.artist, albumArtURL: item.artworkURL, genres: []))
        stop()
    }
}

