//
//  WelcomeView.swift
//  swiftChat
//
//  Created by Aditya Cahyo on 18/05/23.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var vm = WelcomeVM()
    @ObservedObject var appData = AppData()
    
    var body: some View {
        let textMatch = vm.isWelcomeTextMatching()
        
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [.gray.opacity(0.15), .gray.opacity(0.25)],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            HStack {
                if textMatch {
                    Text("Tap anywhere to continue")
                        .font(.caption)
                        .foregroundColor(.defaultFont)
                        .padding(.vertical, 20)
                }
            }.animation(.linear(duration: 0.5), value: textMatch)
            
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        if let unwrappedText: String = vm.welcomeText {
                            Text(unwrappedText).bold()
                                .font(Font.system(.title3, design: .serif))
                                .foregroundColor(.darkGrayFont)
                                .transition(.moveAndFade)
                                .animation(.linear, value: vm.welcomeText)
                        }
                        Spacer()
                    }.frame(maxHeight: 200)
                    Spacer()
                }
                Spacer()
            }
            .padding()
            .padding(.horizontal)
            .contentShape(Rectangle())
            .onTapGesture {
                vm.startNextStep()
            }
            .onChange(of: vm.step, perform: { newValue in
                vm.playWelcomeSentences()
            })
            .onAppear {
                vm.step == -1 ? vm.step += 1 : nil
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
