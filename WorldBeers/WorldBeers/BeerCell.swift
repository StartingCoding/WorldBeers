//
//  BeerCell.swift
//  WorldBeers
//
//  Created by Loris on 26/04/21.
//

import UIKit

class BeerCell: UITableViewCell {
    static let identifier = "BeerCell"

    var containerView = UIView()
    var beerThumbnail = UIImageView()
    var beerName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(containerView)
        containerView.addSubview(beerThumbnail)
        containerView.addSubview(beerName)
        
        configureView()
        setAutoLayoutConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlaceholder(with placeholder: String) {
        beerName.text = placeholder
    }
    
    func setBeer(with beer: Beer) {
        beerName.text = beer.name
        downloadBeerImage(with: beer)
    }
    
    func configureView() {
        containerView.backgroundColor = .orange
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        containerView.layer.shadowOpacity = 1.0
        containerView.layer.masksToBounds = false
        
        beerThumbnail.contentMode = .scaleAspectFit
    }
    
    func setAutoLayoutConstraint() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        beerThumbnail.translatesAutoresizingMaskIntoConstraints = false
        beerName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            
            beerThumbnail.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor),
            beerThumbnail.bottomAnchor.constraint(equalTo: containerView.layoutMarginsGuide.bottomAnchor),
            beerThumbnail.leadingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leadingAnchor),
            beerThumbnail.widthAnchor.constraint(equalTo: beerThumbnail.heightAnchor, multiplier: 1),
            
            beerName.centerYAnchor.constraint(equalTo: beerThumbnail.centerYAnchor),
            beerName.leadingAnchor.constraint(equalTo: beerThumbnail.trailingAnchor),
            beerName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
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
