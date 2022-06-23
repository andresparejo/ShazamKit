//
//  CatalogBuilder.swift
//  RoyalShazamListener
//
//  Created by Eduardo Andres Rodriguez Parejo on 2/22/22.
//

import Foundation
import ShazamKit

final class CatalogBuilder {
    static func build() throws -> SHCustomCatalog {
        var customCatalog = SHCustomCatalog()
        try convert(signatureName: "Trim1.mp4",
                    properties: ShazamCustomMetadata(name: "",
                                               body: "Hi, please pay atention or you will die",
                                               photo: "",
                                               state: .play).toProperties)?.registerIn(catalog: &customCatalog)
        
        try convert(signatureName: "Trim2.mp4",
                    properties: ShazamCustomMetadata(name: "",
                                               body: "Adjust the belt to your body like in titanic",
                                               photo: "",
                                               state: .play).toProperties)?.registerIn(catalog: &customCatalog)
        
        try convert(signatureName: "Trim3.mp4",
                    properties: ShazamCustomMetadata(name: "",
                                               body: "Please rate this video ☠️",
                                               photo: "",
                                               state: .play).toProperties)?.registerIn(catalog: &customCatalog)
        
        return customCatalog
    }
    
    static private func convert(signatureName: String, properties: [SHMediaItemProperty : Any]) throws -> ShazamSignatureMetadata? {
        let extensionType = "shazamsignature"
        guard let signaturePath = Bundle.main.url(forResource: signatureName, withExtension: extensionType) else {
            return nil
        }
        
        let signatureData = try Data(contentsOf: signaturePath)
        let refSignature = try SHSignature(dataRepresentation: signatureData)
        let videoMetadata = SHMediaItem(properties: properties)
        return ShazamSignatureMetadata(signature: refSignature, metadata: [videoMetadata])
    }
}
