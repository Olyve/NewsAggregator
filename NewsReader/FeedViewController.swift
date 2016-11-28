//
//  FeedViewController.swift
//  NewsReader
//
//  Created by Sam Galizia on 11/25/16.
//  Copyright © 2016 Sam Galizia. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {
  let feedParser = FeedParser()
  var articles: [Article] = []
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    
    feedParser.callback = { (parsedArticles: [Article]) -> Void in
      self.articles = parsedArticles
    }
  }
  
  @objc func refreshFeed()
  {
    tableView.reloadData()
    self.refreshControl?.endRefreshing()
  }
}

// MARK: - View Life Cycle
extension FeedViewController {
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    feedParser.startParsingWithContents(of: "http://feeds.feedburner.com/realmio")
    
    title = "My Articles"
    self.refreshControl?.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
    tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
  }
  
  override func viewWillAppear(_ animated: Bool)
  {
    if let index = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: index, animated: true)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.identifier == "ShowArticleDetail",
       let destination = segue.destination as? ArticleDetailViewController
    {
      if let index = tableView.indexPathForSelectedRow?.row {
        destination.request = URLRequest(url: articles[index].link!)
      }
    }
  }
}

// MARK: - Table View Delegate & Data Source
extension FeedViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return articles.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell
    cell?.title = articles[indexPath.row].title!
    cell?.articleDescription = articles[indexPath.row].description!
    
    return cell!
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return 120.0
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    performSegue(withIdentifier: "ShowArticleDetail", sender: self)
  }
}

// MARK: - Helpers
extension FeedViewController {

}
