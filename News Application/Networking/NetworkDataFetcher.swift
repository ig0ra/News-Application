//
//  NetworkDataFetcher.swift
//  News Application
//
//  Created by Admin on 15.02.2021.
//

import Foundation

class NetworkDataFetcher {
    
    var articles: [Article]? = []
    let networkService = NetworkService()
    
    func fetchData(urlString: String, response: @escaping (NewsFeed?) -> Void) {
        networkService.request(urlString: urlString) { (articles) in
            switch articles {
            case .success(let data):
                do {
                    JSONDecoder().keyDecodingStrategy = .convertFromSnakeCase
                    let newsFeed = try JSONDecoder().decode(NewsFeed.self, from: data)

                    response(newsFeed)

                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
}
