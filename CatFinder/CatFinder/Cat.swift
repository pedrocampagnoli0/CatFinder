//
//  Cat.swift
//  CatFinder
//
//  Created by Turma02-20 on 25/06/24.
//

import Foundation

struct Cat : Decodable, Hashable {
    let id: String
    let name: String
    let userId: String
    let ML_model: String
    let photos: [String]
    let lost: Bool
    let registerDate : Date
}
