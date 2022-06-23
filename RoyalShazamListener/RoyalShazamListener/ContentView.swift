//
//  ContentView.swift
//  RoyalShazamListener
//
//  Created by Eduardo Andres Rodriguez Parejo on 2/22/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: {
                    RoomView(viewModel: RoomViewModel())
                        .navigationBarHidden(true)
                }, label: {
                    Image(uiImage: UIImage(named: "home")!)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                })
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(destination: {
                            MusicMediaView(viewModel: MusicMediaViewModel())
                                .navigationBarHidden(true)
                        }, label: {
                            ZStack {
                                Circle()
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .foregroundColor(.cyan)
                                    .padding()
                                Image(systemName: "music.note")
                                    .foregroundColor(.white)
                            }
                            .padding(.top, 20)
                        })
                    }
                    Spacer()
                }
            }.navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13")
    }
}
