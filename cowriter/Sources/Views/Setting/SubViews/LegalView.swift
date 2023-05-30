//
//  MarkdownView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 26/05/23.
//

import SwiftUI

struct LegalView: View {
    @State private var reloadWebView = false
    var type: MarkdownEnum
    
    var body: some View {
        NavigationLink {
            VStack {
                WebView(url: type.link).id(reloadWebView)
            }
            .navigationTitle("Cowriter")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        reloadWebView.toggle()
                    } label: {
                        Label("", systemImage: "arrow.clockwise")
                            .font(.subheadline)
                            .labelStyle(.iconOnly)
                    }
                }
            }
        } label: {
            Text(type.desc)
                .font(.footnote)
                .foregroundColor(.darkGrayFont)
        }
    }
}
