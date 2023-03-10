//
//  User.swift
//  codeChallenge_MarianPliatsko
//
//  Created by mac on 2022-12-10.
//

import Foundation

struct Profile: Decodable {
    let message: String
    let data: User
}

struct User: Decodable {
    let firstName: String
    let userName: String
    let lastName: String
}
