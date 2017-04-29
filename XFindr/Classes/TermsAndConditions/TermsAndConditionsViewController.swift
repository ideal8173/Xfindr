//
//  TermsAndConditionsViewController.swift
//  XFindr
//
//  Created by Rajat on 4/12/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var aviIndicator: UIActivityIndicatorView!
    @IBOutlet var webView: UIWebView!
    
    var tAndC: TAndC = .termsAndCondition
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var strUrl = WebServiceLinks.termsAndPrivacy + "?\(WebServiceConstants.pageType)="
        
        if tAndC == .privacyPolicy {
            strUrl += WebServiceConstants.privacyPolicy
        } else {
            strUrl += WebServiceConstants.termAndConditions
        }
        
        self.webView.setShadowOnView(PredefinedConstants.grayTextColor)
        if let url = URL(string: strUrl) {
            self.aviIndicator.isHidden = false
            self.aviIndicator.center = self.webView.center
            self.webView.loadRequest(URLRequest(url: url))
        }
        
        setNavigation()
    }
    
    func setNavigation() {
        
        if tAndC == .privacyPolicy {
            self.title = ClassesHeader.privacyPolicy()
        } else {
            self.title = ClassesHeader.termsAndConditions()
        }
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    // MARK:- webView Delegate
    /*
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    */
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        aviIndicator.isHidden = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        aviIndicator.isHidden = true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        aviIndicator.isHidden = true
    }


}
