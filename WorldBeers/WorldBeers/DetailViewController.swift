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
            downloadBeerImage()
            description.text = beer.description
            abv.text = "ABV: \(beer.abv)"
            brewerTips.text = beer.brewersTips
        }
    }
    
    //MARK: Networking
    func downloadBeerImage() {
        guard let url = beer?.imageUrl else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    self?.beerImageView.image = UIImage(data: data)
                }
            } else {
                fatalError("Error downloading data image - \(error!.localizedDescription)")
            }
        }.resume()
    }

}
