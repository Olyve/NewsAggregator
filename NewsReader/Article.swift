//
//  Article.swift
//  NewsReader
//
//  Created by Sam Galizia on 11/25/16.
//  Copyright © 2016 Sam Galizia. All rights reserved.
//

import Foundation

class Article {
  var title: String?
  var link: URL?
  var description: String?
  
}

// MARK: - Helpers
extension Article {
  func setLink(with string: String)
  {
    link = URL(string: string)
  }
}
