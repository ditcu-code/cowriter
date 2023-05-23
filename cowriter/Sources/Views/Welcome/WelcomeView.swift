//
//  WelcomeView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 18/05/23.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject var vm = WelcomeVM()
    @ObservedObject var appData = AppData()
    
    var body: some View {
        let isTextMatch = vm.isWelcomeTextMatching()
        
        ZStack(alignment: .bottom) {
            DefaultBackground()
            
            HStack {
                if isTextMatch {
                    Text("Tap anywhere to continue")
                        .font(.caption)
                        .foregroundColor(.defaultFont)
                        .padding(.vertical, 20)
                }
            }.animation(.linear, value: isTextMatch)
            
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        if let unwrappedText: String = vm.welcomeText {
                            Text(unwrappedText).bold()
                                .font(Font.system(.title3, design: .serif))
                                .foregroundColor(.grayFont)
                                .transition(.moveAndFade)
                        }
                        Spacer()
                    }.frame(maxHeight: 200)
                    Spacer()
                }
                Spacer()
            }
            .padding()
            .padding(.horizontal)
            .animation(.linear, value: vm.welcomeText)
            .contentShape(Rectangle())
            .onTapGesture {
                vm.startNextStep()
            }
            .onChange(of: vm.step, perform: { newValue in
                vm.playWelcomeSentences()
            })
            .onAppear {
                vm.firstAppear()
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
