//
//  NewsFeed.swift
//  News Application
//
//  Created by Admin on 10.02.2021.
//

import Foundation

struct NewsFeed: Codable{
    var status: String = ""
    var totalResults: Int = 0
    var articles: [Article]?
}

