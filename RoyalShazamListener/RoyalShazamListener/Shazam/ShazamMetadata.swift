//
//  ShazamMetadata.swift
//  RoyalShazamListener
//
//  Created by Eduardo Andres Rodriguez Parejo on 6/21/22.
//

import Foundation

enum ShazamMetadataState: String {
    case play
    case stop
    case invalid
}

protocol ShazamMetadata {
    var name: String { get }
    var body: String { get }
    var photo: String { get }
    var state: ShazamMetadataState { get }
}
