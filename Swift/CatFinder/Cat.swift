//
//  Cat.swift
//  CatFinder
//
//  Created by Turma02-20 on 25/06/24.
//

import Foundation

struct Cat : Identifiable {
    let id = UUID()
    let name: String;
    let userID = UUID()
    let ML_model: String
    let photos: [String]
    let lost: Bool
    let registerDate : Date
}
