//
//  BeersTableViewController.swift
//  WorldBeers
//
//  Created by Loris on 23/04/21.
//

import UIKit

class BeersTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var beers = [Beer]()
    private var loading = true
    
    var filteredBeers = [Beer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchController()
        downloadBeers()
    }
    
    func configureTableView() {
        title = "WorldBeers"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
    }

    // MARK: - Table View data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading {
            return 1
        } else {
            return filteredBeers.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath)
        
        if loading {
            cell.textLabel?.text = "Loading..."
        } else {
            let beer = filteredBeers[indexPath.row]
            cell.textLabel?.text = beer.name
            cell.detailTextLabel?.text = beer.description
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "ShowDetailSegue",
            let indexPath = tableView.indexPathForSelectedRow,
            let detailViewController = segue.destination as? DetailViewController
            else {
            return
        }
        
        detailViewController.beer = filteredBeers[indexPath.row]
    }
    
    // MARK: - Networking
    
    private func downloadBeers() {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers") else {
            fatalError("There was an error with with the URL")
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                guard let beersDecoded = try? JSONDecoder().decode([Beer].self, from: data) else {
                    fatalError("Error decoding beers")
                }
                
                self?.beers = beersDecoded
                self?.filteredBeers = beersDecoded
            }
            
            self?.loading = false
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }.resume()
    }
}

extension BeersTableViewController: UISearchBarDelegate { }

extension BeersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text!.isEmpty {
            filteredBeers = beers
        } else {
            filteredBeers = beers.filter({ (beer: Beer) -> Bool in
                return beer.name.lowercased().contains(searchController.searchBar.text!.lowercased())
            })
        }
        
        tableView.reloadData()
    }
}
