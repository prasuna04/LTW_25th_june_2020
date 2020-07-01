// WebVC.swift
// LTW
// Created by vaayoo on 27/07/18.
// Copyright © 2018 vaayoo. All rights reserved.

import UIKit
import WebKit
import NVActivityIndicatorView

class WebVC: UIViewController, UIWebViewDelegate ,NVActivityIndicatorViewable,WKNavigationDelegate{
    // @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var webView:WKWebView!
    var myTitle: String?
    var documentUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        let urlString = self.documentUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if (documentUrl?.contains(".pdf"))!{
            DispatchQueue.main.async {
                if let myURL = URL(string:urlString!) {
                    if let data = try? Data(contentsOf: myURL) {
                        self.webView.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: myURL)
                    }
                }
            }
        }else{
            DispatchQueue.main.async {
                self.webViewSetUp(urlString!)
            }
        }
    }
    
    
    private func webViewSetUp( _ searchText:String) {
        let url = URL (string: searchText)
        let requestObj = URLRequest(url: url!)
        webView.load(requestObj)
    }
    @IBAction func btnNextClicked(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.stopAnimating()
        
    }
}
