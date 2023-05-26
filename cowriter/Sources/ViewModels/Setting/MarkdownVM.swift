//
//  MarkdownVM.swift
//  cowriter
//
//  Created by Aditya Cahyo on 26/05/23.
//

import Ink
import Foundation

class MarkdownVM: ObservableObject {
    @Published var loadingMarkdown: Bool = false
    @Published var markdownContent: String = ""
    
    private let cloudKitData = PublicCloudKitService()
    
    deinit {
        markdownContent = ""
    }
    
    @MainActor
    func fetchMarkdownContent(type: MarkdownEnum) async {
        let markdown = await cloudKitData.fetchMarkdown(type: type)
        let convert = self.convertToHTML(markdown: markdown)
        let htmlStart = "<div style=\"padding: 20px; font-family: -apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Oxygen,Ubuntu,Cantarell,Open Sans,Helvetica Neue,sans-serif; font-size: 30px\">"
        let htmlEnd = "</div>"
        self.markdownContent = htmlStart + convert + htmlEnd
    }
    
    private func convertToHTML(markdown: String) -> String {
        let html = MarkdownParser().html(from: markdown)
        return html
    }
    
}
