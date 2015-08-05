//
//  ResultsViewController.swift
//  HanZiBreaker
//

//  Created by HePeng on 7/31/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showWebsite()
    }
    
    var websiteURL: String?
    
    @IBOutlet weak var resultsWebView: UIWebView!
    
    func showWebsite() {
        if let url = websiteURL {
            let website = NSURL(string: url)
            let requestObj = NSURLRequest(URL:website!)
            resultsWebView.loadRequest(requestObj)
        }
    }
    
    
    
}
