//
//  User.swift
//  Fanatics_CodingChallange
//
//  Created by Krunal Mistry on 9/29/22.
//

import Foundation

struct User: Codable, Equatable {
    var id: Int
    var name: String
    var email: String
    var gender: String
    var status: String
}
