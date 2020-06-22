//
//  PostRequest.swift
//  Twitter
//
//  Created by Ivan Mosquera on 16/6/20.
//  Copyright © 2020 Ivan Mosquera. All rights reserved.
//

import Foundation

struct PostRequest: Codable{
    let text:String
    let imageUrl:String?
    let videUrl:String?
    let location: PostRequestLocation?
}
