//
//  EndPoints.swift
//  Twitter
//
//  Created by Ivan Mosquera on 16/6/20.
//  Copyright © 2020 Ivan Mosquera. All rights reserved.
//

import Foundation

struct EndPoints {
    static let domain = "https://platzi-tweets-backend.herokuapp.com/api/v1"
    static let login = EndPoints.domain + "/auth"
    static let register = EndPoints.domain + "/register"
    static let getPosts = EndPoints.domain + "/posts"
    static let post = EndPoints.domain + "/posts"
    static let delete = EndPoints.domain + "/posts/"
}
