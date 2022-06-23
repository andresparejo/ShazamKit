//
//  RoomViewModel.swift
//  RoyalShazamListener
//
//  Created by Eduardo Andres Rodriguez Parejo on 2/22/22.
//

import Foundation
import Combine

final class RoomViewModel: BasicViewModel {
    @Published var displayLulu: Bool = false
    @Published var displayContentLulu: Bool = false
    @Published var contentLuluText: String = ""
    @Published var shazamMetadata: ShazamCustomMetadata? = nil {
        didSet {
            if shazamMetadata != nil, !displayLulu {
                displayLulu.toggle()
                displayContentLulu.toggle()
            }
            
            contentLuluText = shazamMetadata?.body ?? ""
        }
    }
    
    override func setup() {
        let shazamCallback: ShazamMatchingCallback = { [weak self] metadata in
            guard let strongSelf = self, let data = metadata as? ShazamCustomMetadata else {
                return
            }
            
            strongSelf.shazamMetadata = data
        }
        
        do {
            let catalog = try CatalogBuilder.build()
            try self.listener?.setup(type: .custom(catalog), callback: shazamCallback)
        } catch let error {
            print("function: \(#function) error: \(error.localizedDescription)")
        }
    }
}
