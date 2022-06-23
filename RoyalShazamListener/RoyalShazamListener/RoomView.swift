//
//  RoomView.swift
//  RoyalShazamListener
//
//  Created by Eduardo Andres Rodriguez Parejo on 2/22/22.
//

import SwiftUI

struct RoomView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var viewModel: RoomViewModel
    
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(named: "detail")!)
                .resizable()
            VStack {
                Color(.clear)
                    .frame(height: 35, alignment: .center)
                Image(uiImage: UIImage(named: "roomKids")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: 300, alignment: .center)
                    .clipped()
                ZStack {
                    VStack(spacing: 10) {
                        Text("Hi and welcome to:")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.black.opacity(0.7))
                        Text("PLAYGROUND ROOM")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        Text("It’s not a stateroom, it’s home away from home for your adventure. Please tap on LISTEN and watch the video in your TV Room")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        if viewModel.shazamMetadata != nil {
                            ZStack {
                                HStack {
                                    Image("Lulu-and-Mika-LJ_adjusted")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 200, alignment: .center)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 50)
                                            .strokeBorder(.black, lineWidth: 1)
                                            .frame(width: 200, height: 100, alignment: .center)
                                        Text(viewModel.shazamMetadata?.body ?? "")
                                            .frame(width: 160, height: 100, alignment: .center)
                                    }
                                }
                            }
                        }
                        Spacer()
                        Button {
                            viewModel.listen()
                        } label: {
                            Text(viewModel.listenButtonText)
                                .font(.title3)
                                .frame(width: UIScreen.main.bounds.width - 60, height: 40, alignment: .center)
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 60)
                    }
                }
                    .background(.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
            }.onAppear {
                viewModel.setup()
            }
            VStack {
                HStack {
                    Button {
                        viewModel.stop()
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30, alignment: .center)
                            .padding(.top, 60)
                            .padding(.leading, 10)
                            .tint(.black)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView(viewModel: RoomViewModel())
            .previewDevice("iPhone 13")
    }
}
