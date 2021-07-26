//
//  News.swift
//  News App - MVVM with RxSwift
//
//  Created by Jaouher Bejaoui  on 26/7/2021.
//

import Foundation

struct Article  : Decodable{
    let title : String
    let description : String?
}

struct ArticleResponse: Decodable{
    let articles : [Article]
}
