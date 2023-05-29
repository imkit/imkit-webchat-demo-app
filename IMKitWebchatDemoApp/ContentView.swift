//
//  ContentView.swift
//  IMKitWebchatDemoApp
//
//  Created by Howard Sun on 2023/5/28.
//

import SwiftUI
import WebKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
            }
            .padding()
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL?
    
    func makeUIView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
