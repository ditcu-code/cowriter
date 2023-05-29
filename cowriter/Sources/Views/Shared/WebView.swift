//
//  WebView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 25/05/23.
//

import SwiftUI
import WebKit

struct WebViewURL: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator // Set the navigation delegate
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: URL(string: url)!))
    }
    
    // Coordinator class to handle navigation events
    class Coordinator: NSObject, WKNavigationDelegate {
        let webView: WebViewURL
        
        init(_ webView: WebViewURL) {
            self.webView = webView
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            // Display default view when there's an error loading the webpage
            // You can customize this default view to your needs
            let child = UIHostingController(rootView: ErrorMessageView(message: "Failed to load webpage"))
            let parent = UIViewController()
            child.view.translatesAutoresizingMaskIntoConstraints = true
            child.view.frame = parent.view.bounds
            webView.addSubview(child.view)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
