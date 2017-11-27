//
//  ArticulesViewController.swift
//  GettingDataFromOnline
//
//  Created by C4Q on 11/27/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class ArticulesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var articles = [Article]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var stock: Stock = Stock.defaultStock
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        loadData()
    }

    func loadData() {
        let url = "https://api.iextrading.com/1.0/stock/\(stock.symbol)/news/last/20"
        let completion: ([Article]) -> Void = {(onlineArticles: [Article]) in
            self.articles = onlineArticles
        }
        ArticleAPIClient.manager.getArticles(from: url, completionHandler: completion, errorHandler: {print($0)})
    }
}

extension ArticulesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = articles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Article Cell", for: indexPath)
        cell.textLabel?.text = article.headline
        cell.detailTextLabel?.text = article.datetime
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ArticleDetailViewController {
            destination.article = self.articles[tableView.indexPathForSelectedRow!.row]
        }
    }
}
