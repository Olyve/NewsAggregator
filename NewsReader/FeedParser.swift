//
//  FeedParser.swift
//  NewsReader
//
//  Created by Sam Galizia on 11/25/16.
//  Copyright © 2016 Sam Galizia. All rights reserved.
//

import Alamofire
import Foundation
import UIKit

class FeedParser: NSObject, XMLParserDelegate {
  var callback: ((_ articles: [Article]) -> Void)!
  var parser: XMLParser!
  var articles: [Article] = []
  var currentItem: Article?
  var currentElement: String?
  
  func startParsingWithContents(of url: String)
  {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    Alamofire.request(url).responseData { response in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      
      guard let data = response.data
        else { return print("There was an error with the returned data") }
      
      debugPrint("\(response)")
      
      self.parser = XMLParser(data: data)
      self.parser.delegate = self
      self.parser.parse()
    }
  }
}

// MARK: - XMLParserDelegate
extension FeedParser {
  func parserDidStartDocument(_ parser: XMLParser)
  {
    print("Started parsing document...")
  }
  
  func parserDidEndDocument(_ parser: XMLParser)
  {
    print("Finished parsing document")
    callback(articles)
  }
  
  func parser(_ parser: XMLParser,
              didStartElement elementName: String,
              namespaceURI: String?,
              qualifiedName qName: String?,
              attributes attributeDict: [String : String] = [:])
  {
    if elementName == "item" {
      currentItem = Article()
    }
    
    currentElement = ""
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String)
  {
    currentElement? += string
  }
  
  func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
  {
    print(parseError.localizedDescription)
  }
  
  func parser(_ parser: XMLParser,
              didEndElement elementName: String,
              namespaceURI: String?,
              qualifiedName qName: String?)
  {
    if elementName == "item" {
      if let item = currentItem,
         articles.count < 20 {
        articles.append(item)
      }
      
      return currentItem = nil
    }
    
    if let item = currentItem {
      if elementName == "title" {
        item.title = String(htmlEncodedString: currentElement!)
      }
      
      if elementName == "link" {
        item.setLink(with: currentElement!)
      }
      
      if elementName == "description" {
        item.description = String(htmlEncodedString: currentElement!)
      }
    }
  }
}

// String Extension to Decode HTML Characters
extension String {
  init(htmlEncodedString: String) {
    self.init()
    guard let encodedData = htmlEncodedString.data(using: .utf8) else {
      self = htmlEncodedString
      return
    }
    
    let attributedOptions: [String : Any] = [
      NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
      NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
    ]
    
    do {
      let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
      self = attributedString.string
    }
    catch {
      print("Error: \(error.localizedDescription)")
      self = htmlEncodedString
    }
  }
}






