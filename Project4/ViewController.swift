//
//  ViewController.swift
//  Project4
//
//  Created by Aharon Seidman on 1/6/24.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webview:WKWebView!
    var progressView:UIProgressView!
//    var websiteClickedOriginally: String?
    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func loadView() {
        webview = WKWebView()
        webview.navigationDelegate = self
        view = webview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string: "https://www.apple.com/")!
        webview.load(URLRequest(url: url))
        webview.allowsBackForwardNavigationGestures = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webview, action: #selector(webview.reload))
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webview, action: #selector(webview.goForward))
        let backward = UIBarButtonItem(title: "Backward", style: .plain, target: webview, action: #selector(webview.goBack))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        toolbarItems = [forward,backward,progressButton, refresh]
        navigationController?.isToolbarHidden = false
        
        webview.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),options: .new, context: nil)
    }
    
    @objc func openTapped(){
        let vc = UIAlertController(title: "Open page", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            vc.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
       
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        vc.popoverPresentationController?.barButtonItem = navigationController?.navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
                     
                     
    }
    
    func openPage(action: UIAlertAction){
        let url = URL(string: "https://" + action.title!)!
        webview.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.progress = Float(webview.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        print("called once")
        if let host = url?.host{
            print(host)
            for website in websites {
                if host.contains(website){
                    decisionHandler(.allow)
                    return
                }
            }
        } 
        let ac = UIAlertController(title: "Webpage Blocked", message: "Sorry you're a shkutz -- only the allowed websites", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
        decisionHandler(.cancel)
    }
        
        
        

}




