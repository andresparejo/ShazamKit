//
//  BasicViewModel.swift
//  RoyalShazamListener
//
//  Created by Eduardo Andres Rodriguez Parejo on 6/22/22.
//

import Foundation
import Combine

class BasicViewModel: ObservableObject {
    @Published var listenButtonText: String = ButtonState.listen.rawValue.capitalized
    @Published var listenButtonState: ButtonState = .listen {
        didSet {
            self.listenButtonText = listenButtonState.rawValue.capitalized
        }
    }
    
    internal let listener: ShazamListener?
    
    init() {
        listener = .init()
    }
    
    open func setup() {
        
    }
    
    func listen() {
        guard !listenButtonState.isListening else {
            stop()
            return
        }
        
        do {
            try listener?.listen()
            listenButtonState = .listening
        } catch let error {
            print("function: \(#function) error: \(error.localizedDescription)")
        }
    }
    
    func stop() {
        listener?.stop()
        listenButtonState = .listen
    }
    
}
