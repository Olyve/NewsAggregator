//
//  ArticleCell.swift
//  NewsReader
//
//  Created by Sam Galizia on 11/25/16.
//  Copyright © 2016 Sam Galizia. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
  var title: String = "" {
    didSet { titleLabel.text? = title }
  }
  
  var articleDescription: String = "" {
    didSet { descriptionLabel.text = articleDescription }
  }
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
  }
}
