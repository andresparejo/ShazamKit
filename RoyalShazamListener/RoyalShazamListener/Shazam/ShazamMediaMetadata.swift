//
//  ShazamMediaMetadata.swift
//  RoyalShazamListener
//
//  Created by Eduardo Andres Rodriguez Parejo on 6/21/22.
//

import Foundation

struct ShazamMediaMetadata: Decodable {
    let title: String?
    let subtitle: String?
    let artistName: String?
    let albumArtURL: URL?
    let genres: [String]
}

extension ShazamMediaMetadata: ShazamMetadata {
    var name: String {
        return self.title ?? ""
    }
    
    var body: String {
        return self.subtitle ?? ""
    }
    
    var photo: String {
        return self.albumArtURL?.absoluteString ?? ""
    }
    
    var state: ShazamMetadataState {
        return .invalid
    }
}
