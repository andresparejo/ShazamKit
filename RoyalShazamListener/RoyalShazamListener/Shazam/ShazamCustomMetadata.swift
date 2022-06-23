//
//  RoyalAudioMetadata.swift
//  RoyalShazamListener
//
//  Created by Eduardo Andres Rodriguez Parejo on 4/22/22.
//

import Foundation
import ShazamKit
import UIKit

struct ShazamCustomMetadata: ShazamMetadata {
    let name: String
    let body: String
    let photo: String
    let state: ShazamMetadataState
}

extension ShazamCustomMetadata {
    var toProperties: [SHMediaItemProperty : Any] {
        return [
            .title: name,
            .body: body,
            .photo: photo,
            .state: state.rawValue
        ]
    }
    
    static func convertToMetaData(item: SHMatchedMediaItem) -> ShazamCustomMetadata {
        return ShazamCustomMetadata(name: item.title ?? "",
                              body: item.body ?? "",
                              photo: item.photo ?? "",
                              state: ShazamMetadataState(rawValue: item.state ?? "") ?? .invalid)
    }
}

extension SHMediaItemProperty {
    static let body = SHMediaItemProperty("Body")
    static let photo = SHMediaItemProperty("Photo")
    static let state = SHMediaItemProperty("State")
}

// Add a property for returning the episode number using a subscript.
extension SHMediaItem {
    var body: String? {
        return self[.body] as? String
    }
    
    var photo: String? {
        return self[.photo] as? String
    }
    
    var state: String? {
        return self[.state] as? String
    }
}
