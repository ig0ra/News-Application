//
//  Article.swift
//  News Application
//
//  Created by Admin on 10.02.2021.
//

import Foundation

struct Article: Codable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

