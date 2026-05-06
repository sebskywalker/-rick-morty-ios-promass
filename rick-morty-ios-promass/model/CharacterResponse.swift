//
//  CharacterResponse.swift
//  rick-morty-ios-promass
//
//  Created by seb's on 5/6/26.
//

import Foundation

struct CharacterResponse: Codable {
    let info: Info
    let results: [Character]
}
