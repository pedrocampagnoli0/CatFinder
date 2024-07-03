//
//  ViewModel.swift
//  CatFinder
//
//  Created by Turma02-17 on 02/07/24.
//

import Foundation

class ViewModel : ObservableObject {
    @Published var cats: [Cat] = []
    @Published var users: [User] = []
    // Method
    
    func fetchCats() {
        guard let url = URL(string: "http://192.168.128.251:1880/cat") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let jsonDecodified = try JSONDecoder().decode([Cat].self, from: data)
                
                DispatchQueue.main.async {
                    self?.cats = jsonDecodified
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchUsers() {
        guard let url = URL(string: "http://192.168.128.251:1880/user") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let jsonDecodified = try JSONDecoder().decode([User].self, from: data)
                
                DispatchQueue.main.async {
                    self?.users = jsonDecodified
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
