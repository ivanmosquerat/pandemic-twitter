//
//  LoginResponse.swift
//  Twitter
//
//  Created by Ivan Mosquera on 16/6/20.
//  Copyright © 2020 Ivan Mosquera. All rights reserved.
//

import Foundation

struct LoginResponse: Codable{
    let user: User
    let token: String
}
