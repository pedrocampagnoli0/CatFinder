//
//  User.swift
//  CatFinder
//
//  Created by Turma02-20 on 25/06/24.
//

import Foundation

struct User : Identifiable {
    let id = UUID()
    let name : String
    let pwd : String
    let email : String
    let phone : String
    let catId = UUID()
    let registerDate : Date
}
