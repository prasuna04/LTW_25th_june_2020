//  WebPageVC.swift
//  LTW
//  Created by Ranjeet Raushan on 18/03/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit
import NVActivityIndicatorView
import WebKit
class WebPageVC: UIViewController,NVActivityIndicatorViewable,WKUIDelegate,WKNavigationDelegate {
    
    var myTitle: String?
    var pageUrl: String?
    
    @IBOutlet weak var wEbView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = myTitle
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        wEbView.uiDelegate = self
        wEbView.navigationDelegate = self

        if let url = URL(string: pageUrl!) {
            let request = URLRequest(url: url)
            wEbView.load(request)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.stopAnimating()

    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))

    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.stopAnimating()

    }
    
}
/*extension WebPageVC: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.stopAnimating()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.stopAnimating()
    }
}*/
