//
//  DetailViewController.swift
//  WorldBeers
//
//  Created by Loris on 25/04/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
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
           let nameLabel = nameLabel {
            nameLabel.text = beer.name
            title = beer.name
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
