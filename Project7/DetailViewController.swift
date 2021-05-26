//
//  DetailViewController.swift
//  Project7
//
//  Created by Azat Kaiumov on 24.05.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var detailItem: Petition?
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else {
            return
        }
        
        title = detailItem.title
        navigationItem.largeTitleDisplayMode = .always
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        <h2>\(detailItem.title)</h2>
        <h3>Signatures: \(detailItem.signatureCount)</h3>
        \(detailItem.body.replacingOccurrences(of: "\n", with: "<br />"))
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
