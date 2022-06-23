//
//  ShazamSignatureMetadata.swift
//  RoyalShazamListener
//
//  Created by Eduardo Andres Rodriguez Parejo on 5/3/22.
//

import Foundation
import ShazamKit

struct ShazamSignatureMetadata {
    let signature: SHSignature
    let metadata: [SHMediaItem]
}

extension ShazamSignatureMetadata {
    func registerIn(catalog: inout SHCustomCatalog) throws {
        try catalog.addReferenceSignature(self.signature, representing: self.metadata)
    }
}
