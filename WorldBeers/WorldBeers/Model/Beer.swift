//
//  Beer.swift
//  WorldBeers
//
//  Created by Loris on 24/04/21.
//

import Foundation

struct Beer: Codable {
    let name: String
    let tagline: String
    let abv: Double
    let description: String
    let imageUrl: URL
    let brewersTips: String
}
