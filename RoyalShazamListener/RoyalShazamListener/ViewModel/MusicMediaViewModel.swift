//
//  MusicMediaViewModel.swift
//  RoyalShazamListener
//
//  Created by Eduardo Andres Rodriguez Parejo on 6/21/22.
//

import Foundation


final class MusicMediaViewModel: BasicViewModel {
    @Published var mediaItem: ShazamMediaMetadata?
    
    override func setup() {
        let shazamCallback: ShazamMatchingCallback = { [weak self] metadata in
            guard let strongSelf = self, let data = metadata as? ShazamMediaMetadata else {
                return
            }
            strongSelf.mediaItem = data
            strongSelf.listenButtonState = .listen
            strongSelf.stop()
        }
        
        do {
            try self.listener?.setup(type: .music, callback: shazamCallback)
        } catch let error {
            print("function: \(#function) error: \(error.localizedDescription)")
        }
    }
}
