//
//  RegisterRequest.swift
//  Twitter
//
//  Created by Ivan Mosquera on 16/6/20.
//  Copyright © 2020 Ivan Mosquera. All rights reserved.
//

import Foundation

struct RegisterRequest: Codable{
    let email: String
    let password: String
    let names: String
}
