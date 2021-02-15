//
//  ViewController.swift
//  News Application
//
//  Created by Admin on 10.02.2021.
//

import UIKit

class ViewController: UIViewController  {
    
    let networkDataFetcher = NetworkDataFetcher()
    var apiResponse: NewsFeed? = nil
    private var timer: Timer?
    let searchController = UISearchController(searchResultsController: nil)
    
    var articles: [Article]? = []
    var category = "technology"
    
    
    var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return refreshControl
    }()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let menuManager = MenuManager()
    
    @IBAction func menuPressed(_ sender: Any) {
        menuManager.openMenu()
        menuManager.mainVC = self
    }
    
    @objc private func refresh(){

        DispatchQueue.main.async{
            
            self.fetchArticles()
            self.refresher.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refresher
        self.refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
 //       tableView.addSubview(refresher)
        setupTableView()
        setupSearchBar()
        fetchArticles()
    }
    
    func fetchArticles(){
        let urlString = "http://newsapi.org/v2/top-headlines?country=us&category=\(category)&sortedBy=publishedAt&pageSize=100&apiKey=6fd8a61d309e483cbc52b8457b865ed7"
            self.networkDataFetcher.fetchData(urlString: urlString) { (apiResponse) in
                guard let apiResponse = apiResponse else { return }
                self.apiResponse = apiResponse
                self.articles = apiResponse.articles

                self.tableView.reloadData()
            }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "articleCell")
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = false
        searchController.obscuresBackgroundDuringPresentation = false
    }

}

// MARK: - UIImageView
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let article = self.articles?[indexPath.item]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? ArticleCell {
            
            cell.titleLabel.text = article?.title ?? "0"
            cell.descriptionLabel.text = article?.description ?? "no description"
            cell.authorLabel.text = article?.author ?? "no author"
            cell.sourceLabel.text = articles?[indexPath.row].source?.name ?? "no source"
            if article?.urlToImage != nil{
                cell.articleImageView.downloaded(from: (article?.urlToImage!)!)}

            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! WebViewController
        
        webVC.url = self.articles?[indexPath.item].url
        
        self.present(webVC, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let urlString = "https://newsapi.org/v2/everything?q=\(searchText)&apiKey=6fd8a61d309e483cbc52b8457b865ed7"

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchData(urlString: urlString) { (apiResponse) in
                guard let apiResponse = apiResponse else { return }
                self.apiResponse = apiResponse
                self.articles = apiResponse.articles

                self.tableView.reloadData()
            }

        })
        
    }
}

