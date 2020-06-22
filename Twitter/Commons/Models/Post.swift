//
//  Post.swift
//  Twitter
//
//  Created by Ivan Mosquera on 16/6/20.
//  Copyright © 2020 Ivan Mosquera. All rights reserved.
//

import Foundation

struct Post: Codable{
    let id: String
    let author: User
    let imageUrl: String
    let text: String
    let videoUrl: String
    let location: Location
    let hasVideo: Bool
    let hasImage: Bool
    let hasLocation: Bool
    let createdAt: String
}

struct Location: Codable{
    let latitude: Double
    let longitude: Double
}
