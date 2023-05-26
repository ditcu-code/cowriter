//
//  MarkdownView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 26/05/23.
//

import SwiftUI

struct MarkdownView: View {
    @StateObject var vm = MarkdownVM()
    var type: MarkdownEnum
    
    var body: some View {
        NavigationLink {
            VStack {
                if vm.loadingMarkdown {
                    CircularLoading()
                } else {
                    WebView(htmlContent: vm.markdownContent)
                        .task {
                            await vm.fetchMarkdownContent(type: type)
                        }
                }
            }
            .navigationTitle(type.desc)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await vm.fetchMarkdownContent(type: type)
                        }
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
