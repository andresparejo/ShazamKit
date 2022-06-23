//
//  listenButtonState.swift
//  RoyalShazamListener
//
//  Created by Eduardo Andres Rodriguez Parejo on 6/21/22.
//

import Foundation

enum ButtonState: String {
    case listen
    case listening
    case stop
    case done
    
    var isListening: Bool {
        return self == .listening
    }
}
