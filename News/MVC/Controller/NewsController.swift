//
//  NewsController.swift
//  News
//
//  Created by Dinesh Kumar on 20/12/22.
//

import UIKit

class NewsController: UIViewController {

    @IBOutlet weak var indicatorView : UIView!
    @IBOutlet weak var newsTableView : UITableView!
    var refreshControl = UIRefreshControl()
    var isFetchingData = false
    var willLoadMoreData = false
    var pageNumber : Int = 1
    var pageSize : Int = 10
    var newsArray = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPullToRefreshControl()
        showIndicator()
        fetchNewsData()
    }
}


//MARK: UITableView DataSource & Delegates
extension NewsController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: NewTableViewCell.identifier, for: indexPath) as! NewTableViewCell
        
        cell.updateData(artical: self.newsArray[indexPath.row])
        
        self.loadMore(indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(
            NewsDetailController.newsDetailController(artical: newsArray[indexPath.row]),
            animated: true)
    }
}


//MARK: Fetching Data
extension NewsController{
    
    func fetchNewsData() -> Void {
        isFetchingData = true
        ApiManager(requestData: ["qinTitle" : "ios","from" : "2022-11- 27", "pageSize" : pageSize, "page" : pageNumber], url: nil,service: .newslist,method: .get, isJSONRequest: false).executeQuery{ (result : Result<ArticleResult,Error>) in
            self.isFetchingData = false
            self.hideIndicator()
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let success):
                guard let items = success.articles else {
                    self.willLoadMoreData = false
                    return
                }
                self.pageNumber = self.pageNumber + 1
                self.willLoadMoreData = true
                self.newsArray.append(contentsOf: items)
                self.newsTableView.reloadData()
            case .failure(let failure):
                self.isFetchingData = false
                self.hideIndicator()
                self.refreshControl.endRefreshing()
                self.alert(alertTitle: "Error", alertMessage: failure.localizedDescription)
                break
                
            }
        }
    }
    
    func loadMore(indexPath : IndexPath) -> Void{
        if self.newsArray.count - 2 == indexPath.row && !isFetchingData && willLoadMoreData{
            showIndicator()
            fetchNewsData()
        }
    }
    
}

//MARK: Manage UIActivityIndicator show/hide methods
extension NewsController{
    func showIndicator() -> Void {
        newsTableView.tableFooterView = indicatorView
    }
    
    func hideIndicator() -> Void{
        newsTableView.tableFooterView = UIView()
    }
}

//MARK: Setup Pull To Refresh Controller
extension NewsController{
    
    func setupPullToRefreshControl() -> Void {
        self.newsTableView.insertSubview(refreshControl, at: 0)
        refreshControl.addTarget(self, action: #selector(pullToRefreshData), for: .valueChanged)
    }
    
    
    @objc func pullToRefreshData() -> Void {
        pageNumber = 1
        newsArray.removeAll()
        self.newsTableView.reloadData()
        fetchNewsData()
    }
    
}
