//
//  User.swift
//  CatFinder
//
//  Created by Turma02-20 on 25/06/24.
//

import Foundation

struct User : Decodable, Hashable {
    let id: String
    let name : String
    let pwd : String
    let email : String
    let phone : String
    let catId: String
    let registerDate : Date
}
