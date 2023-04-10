//
//  GrammarButtonView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import SwiftUI

struct GrammarActionsView: View {
    @StateObject var vm: GrammarVM
    @Binding var isRephrase: Bool
    
    var body: some View {
        HStack {
            Button {
                vm.check()
                isRephrase = false
            } label: {
                Label("Check", systemImage: "checkmark.square")
            }.disabled(vm.loading)
            Button {
                vm.rephrase()
                isRephrase = true
            } label: {
                Text("Rephrase")
            }.disabled(vm.loading)
        }.buttonStyle(.borderedProminent).font(.title2)
    }
}

//struct GrammarActionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GrammarActionsView(vm: GrammarVM())
//    }
//}
