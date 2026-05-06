//
//  Info.swift
//  rick-morty-ios-promass
//
//  Created by seb's on 5/6/26.
//

import Foundation

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
