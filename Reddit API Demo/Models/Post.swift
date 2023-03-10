//
//  Post.swift
//  Reddit API Demo
//
//  Created by Stef Castillo on 1/14/23.
//

import Foundation

struct TopLevelObject: Decodable {
    let data: SecondLevelObject
    
}

struct SecondLevelObject: Decodable {
    let children: [ThirdLevelObject]
}

struct ThirdLevelObject: Decodable {
    let data: Post
}

struct Post: Decodable{
    let title: String
    let ups: Int
    let thumbnail: String
}
