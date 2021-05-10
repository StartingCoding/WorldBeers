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
        downloadBeers()
        configureTableView()
        configureSearchController()
    }
    
    func configureTableView() {
        title = "WorldBeers"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.separatorColor = .clear
        tableView.register(BeerCell.self, forCellReuseIdentifier: BeerCell.identifier)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: BeerCell.identifier) as! BeerCell
        
        if loading {
            cell.setPlaceholder(with: "Loading...")
        } else {
            let beer = filteredBeers[indexPath.row]
            cell.setBeer(with: beer)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            detailVC.beer = filteredBeers[indexPath.row]
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // MARK: - Networking
    
    func downloadBeers() {
        NetworkManager.shared.fetchBeers { [weak self] result in
            self?.beers = result
            self?.filteredBeers = self?.beers ?? [Beer]()
            self?.loading = false
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
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
