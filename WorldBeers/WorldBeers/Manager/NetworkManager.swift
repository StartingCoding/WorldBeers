//
//  NetworkManager.swift
//  WorldBeers
//
//  Created by Loris on 27/04/21.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.punkapi.com/v2/beers"
    
    private init() {}
    
    // Downloading Beers from internet
    func fetchBeers(completed: @escaping ([Beer]) -> Void) {
        guard let url = URL(string: baseURL) else {
            fatalError("There was an error with with the URL")
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                guard let beersDecoded = try? decoder.decode([Beer].self, from: data) else {
                    fatalError("Error decoding beers")
                }
                
                completed(beersDecoded)
            }
        }.resume()
    }
    
    // Downloading Thumbnail
    func fecthBeerThumbnail(from url: URL, completed: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                completed(data)
            } else {
                fatalError("Error downloading data image - \(error!.localizedDescription)")
            }
        }.resume()
    }
    
}
