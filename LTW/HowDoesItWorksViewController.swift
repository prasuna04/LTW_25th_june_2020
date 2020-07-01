//  HowDoesItWorksViewController.swift
//  LTW
//  Created by vaayoo on 10/10/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import WebKit
import NVActivityIndicatorView
class HowDoesItWorksViewController: UIViewController,UIWebViewDelegate, WKNavigationDelegate,NVActivityIndicatorViewable {
    var mytitle:String!
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        if mytitle == "termsAndConditions"{
            startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
            webView.load(URLRequest(url: URL.init(string: "https://learnteachworld.com/termsandcondtions.html")!))
        }else{
            startAnimating(type:.lineScale,color: UIColor.init(hex: "2DA9EC"))
            webView.load(URLRequest(url: URL.init(string: "http://learnteachworld.com/howdoesitwork.html")!))
        }
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.stopAnimating()
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let navigationController = navigationController else { return }
        navigationController.view.backgroundColor = UIColor.init(hex:"2DA9EC")
        if (self.navigationController?.navigationBar) != nil {
            navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
        if mytitle == "termsAndConditions"{
            self.navigationController?.navigationBar.topItem?.title = " "
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.title = "Terms and Conditions"
        }else{
            self.navigationController?.navigationBar.topItem?.title = " "
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.title = "How does it work"
        }
        
    }
}
