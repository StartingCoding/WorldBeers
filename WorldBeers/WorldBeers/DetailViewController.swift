//
//  DetailViewController.swift
//  WorldBeers
//
//  Created by Loris on 25/04/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tagline: UILabel!
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var brewersTipsLabel: UILabel!
    
    var beer: Beer? {
        didSet {
            configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView() {
        if let beer = beer,
           let tagline = tagline,
           let description = descriptionTextView,
           let abv = abvLabel,
           let brewerTips = brewersTipsLabel {
            title = beer.name
            tagline.text = beer.tagline
            downloadBeerThumbnail()
            description.text = beer.description
            abv.text = "ABV: \(beer.abv)"
            brewerTips.text = "Brewer Tip:\n\(beer.brewersTips)"
        }
    }
    
    //MARK: Networking
    func downloadBeerThumbnail() {
        guard let url = beer?.imageUrl else {
            fatalError("There was an error with with the URL")
        }
        
        NetworkManager.shared.fecthBeerThumbnail(from: url) { [weak self] result in
            DispatchQueue.main.async {
                self?.beerImageView.image = UIImage(data: result)
            }
        }
    }

}
