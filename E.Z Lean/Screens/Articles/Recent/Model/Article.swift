//
//  Article.swift
//  E.Z Lean
//
//  Created by Duy Anh on 2/7/17.
//  Copyright © 2017 E.Z Lean. All rights reserved.
//

import RxDataSources

class Article: Hashable, IdentifiableType {
    var title: String
    var summary: String
    var contentLink: String
    var thumbnailImageLink: String
    
    init(title: String, summary: String ,contentLink: String, imageLink: String) {
        self.title = title
        self.summary = summary
        self.contentLink = contentLink
        self.thumbnailImageLink = imageLink
    }
    
    public static func ==(lhs: Article, rhs: Article) -> Bool {
        return lhs.contentLink == rhs.contentLink
    }
    
    var hashValue: Int {
        return contentLink.hashValue
    }
    
    typealias Identity = Article
    var identity: Article { return self }
}
