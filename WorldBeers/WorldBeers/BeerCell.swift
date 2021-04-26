//
//  BeerCell.swift
//  WorldBeers
//
//  Created by Loris on 26/04/21.
//

import UIKit

class BeerCell: UITableViewCell {

    @IBOutlet weak var beerName: UILabel!
    @IBOutlet weak var beerThumbnail: UIImageView!
    
    func setBeer(with beer: Beer) {
        beerName.text = beer.name
        downloadBeerImage(with: beer)
    }
    
    func setPlaceholder(with placeholder: String) {
        beerName.text = placeholder
    }
    
    //MARK: Networking
    func downloadBeerImage(with beer: Beer) {
        URLSession.shared.dataTask(with: beer.imageUrl) { [weak self] (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    self?.beerThumbnail.image = UIImage(data: data)
                }
            } else {
                fatalError("Error downloading data image - \(error!.localizedDescription)")
            }
        }.resume()
    }
}
