//
//  WebView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 25/05/23.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: String
    var activityIndicator: UIActivityIndicatorView! = UIActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 30, y: (UIScreen.main.bounds.height / 2) - 30, width: 60, height: 60))
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        let webview = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), configuration: makeViewConfiguration())
        webview.navigationDelegate = context.coordinator
        
        let request = URLRequest(url: URL(string: url)!, cachePolicy: .returnCacheDataElseLoad)
        webview.allowsBackForwardNavigationGestures = true
        webview.allowsLinkPreview = true
        webview.load(request)
        
        view.addSubview(webview)
        activityIndicator.backgroundColor = UIColor.gray
        activityIndicator.startAnimating()
        activityIndicator.color = UIColor.white
        activityIndicator.layer.cornerRadius = 8
        activityIndicator.clipsToBounds = true
        
        view.addSubview(activityIndicator)
        return view
    }
    
    func updateUIView(_ webview: UIView, context: UIViewRepresentableContext<WebView>) {
    }
    
    func makeViewConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        let dropSharedWorkersScript = WKUserScript(source: "delete window.SharedWorker;", injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        configuration.userContentController.addUserScript(dropSharedWorkersScript)
        return configuration
    }
    
    func makeCoordinator() -> WebViewHelper {
        WebViewHelper(self)
    }
}

class WebViewHelper: NSObject, WKNavigationDelegate {
    var parent: WebView
    
    init(_ parent: WebView) {
        self.parent = parent
        super.init()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        parent.activityIndicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        parent.activityIndicator.isHidden = true
        print("error: \(error)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        parent.activityIndicator.isHidden = true
        let child = UIHostingController(rootView: ErrorMessageView(message: "Failed to load webpage"))
        let parent = UIViewController()
        child.view.translatesAutoresizingMaskIntoConstraints = true
        child.view.frame = parent.view.bounds
        webView.addSubview(child.view)
        print("error \(error)")
    }
}
