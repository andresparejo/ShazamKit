//
//  MusicMediaView.swift
//  RoyalShazamListener
//
//  Created by Eduardo Andres Rodriguez Parejo on 6/21/22.
//

import SwiftUI
import Combine

struct MusicMediaView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var viewModel: MusicMediaViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0, green: 0, blue: 153/255.0, opacity: 1), Color(red: 0, green: 0, blue: 51/255.0, opacity: 1)], startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            if viewModel.mediaItem == nil {
                VStack {
                    Spacer()
                    Text("Do you like the")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text("music on board?")
                        .font(.title)
                        .foregroundColor(.white)
                        .bold()
                    Image(systemName: "music.quarternote.3")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 200, height: 200, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                        .padding(.vertical, 50)
                    Text("Seek and add to your list")
                        .font(.title2)
                        .foregroundColor(.white)
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
                    .padding(.bottom, 50)
                }
            } else {
                ZStack {
                    AsyncImage(url: viewModel.mediaItem?.albumArtURL)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(20)
                        .blur(radius: 20)
                        .opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Spacer()
                        AsyncImage(url: viewModel.mediaItem?.albumArtURL,
                                   content: { image in
                                        image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 300, height: 300)
                                }, placeholder: {
                                    ProgressView()
                                })
                            .aspectRatio(contentMode: .fit)
                        Text(viewModel.mediaItem?.title ?? "")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text(viewModel.mediaItem?.subtitle ?? "")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Button {
                            openMusic()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .frame(width: UIScreen.main.bounds.width - 60, height: 40, alignment: .center)
                                    .foregroundColor(.white)
                                HStack {
                                    Image(systemName: "applelogo")
                                        .tint(.black)
                                    Text("Open in Music")
                                       .font(.title3)
                                       .foregroundColor(.black)
                                }
                            }
                        }
                        .padding(.bottom, 10)
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
                        .padding(.bottom, 50)
                    }
                }
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
                            .padding(.top, 20)
                            .padding(.leading, 20)
                            .tint(.white)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            viewModel.setup()
         }
    }
    
    private func openMusic() {
        let urlString = "music://music.apple.com/library"
                                                if let url = URL(string: urlString) { UIApplication.shared.open(url)
                                                }
    }
}

struct MusicMediaView_Previews: PreviewProvider {
    static var previews: some View {
        MusicMediaView(viewModel: MusicMediaViewModel())
    }
}
