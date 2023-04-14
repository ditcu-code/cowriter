//
//  CowriterView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct CowriterView: View {
    @State var text: String = ""
    @ObservedObject var vm: CowriterVM = CowriterVM()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.2).ignoresSafeArea()
                VStack() {
                    CowriterLogo()
                    Prompter(vm: vm)
                    PromptHint(vm: vm)
                }.navigationBarTitleDisplayMode(.inline)
            }
            .toolbar {
                Button {
                    print("")
                } label: {
                    Label("Hello", systemImage: "gearshape")
                }
            }
        }
        .customFont()
    }
}

struct CowriterView_Previews: PreviewProvider {
    
    static var previews: some View {
        CowriterView()
    }
}
