//
//  ArticleDetailViewController.swift
//  NewsReader
//
//  Created by Sam Galizia on 11/26/16.
//  Copyright © 2016 Sam Galizia. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {
  var request: URLRequest?
  
  @IBOutlet weak var webView: UIWebView!
  
  override func viewDidLoad()
  {
    if let request = request {
      webView.loadRequest(request)
    }
  }
  
  @IBAction func backButtonTapped(_ sender: Any)
  {
    dismiss(animated: true, completion: nil)
  }
  
}
