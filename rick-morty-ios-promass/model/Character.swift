//
//  Character.swift
//  rick-morty-ios-promass
//
//  Created by seb's on 5/6/26.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let image: String
    
    let type: String?
    let gender: String?
    let origin: CharacterLocation?
    let location: CharacterLocation?
    let episode: [String]?
}

struct CharacterLocation: Codable {
    let name: String
}
