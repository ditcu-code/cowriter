//
//  GrammarButtonView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import SwiftUI

struct GrammarActionsView: View {
    var body: some View {
        HStack {
            Button {
                print("check")
            } label: {
                Label("Check", systemImage: "checkmark.square")
            }
            Button {
                print("check")
            } label: {
                Text("Rephrase")
            }
        }.buttonStyle(.borderedProminent).font(.title2)
    }
}

struct GrammarActionsView_Previews: PreviewProvider {
    static var previews: some View {
        GrammarActionsView()
    }
}
