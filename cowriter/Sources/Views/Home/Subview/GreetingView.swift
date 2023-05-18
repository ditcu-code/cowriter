//
//  GreetingView.swift
//  swiftChat
//
//  Created by Aditya Cahyo on 08/05/23.
//

import SwiftUI

struct GreetingView: View {
    @StateObject var profile = ProfileManager()
    @StateObject var vm = GreetingVM()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                if let unwrappedText: String = vm.greeting1 {
                    Text(unwrappedText).bold()
                        .font(Font.system(.title3, design: .serif))
                        .foregroundColor(.defaultFont)
                        .transition(.moveAndFade)
                }
                
                if let unwrappedText: String = vm.greeting2 {
                    Text(unwrappedText).bold()
                        .font(Font.system(.title2, design: .serif))
                        .foregroundColor(.grayFont)
                        .transition(.moveAndFade)
                }
                Spacer()
            }.frame(maxHeight: 130)
            Spacer()
        }
        .padding()
        .padding(.horizontal)
        .animation(.interpolatingSpring(stiffness: 60, damping: 12), value: [vm.greeting1, vm.greeting2])
        .onAppear {
            vm.startGreetingsAnimation(profileName: profile.user?.wrappedName)
        }
    }
}

struct GreetingView_Previews: PreviewProvider {
    static var previews: some View {
        GreetingView()
    }
}
