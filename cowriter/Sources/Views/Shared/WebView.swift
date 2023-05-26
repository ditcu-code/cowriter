//
//  WebView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 25/05/23.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let htmlContent: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
    
}
