//
//  SearchViewController.swift
//  Movie Time
//
//  Created by Yury Kruk on 08.12.2021.
//

import UIKit

struct SearchSection {
    let title: String
    let result: [SearchResult]
}

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - Search Controller
    private let searchController: UISearchController = {
        let vc = UISearchController()
        vc.searchBar.placeholder = "Movies, TV Shows, Persons"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    // MARK: - TableView
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.register(MediaSectionTableViewCell.nib(), forCellReuseIdentifier: MediaSectionTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    // MARK: - Model
    private var sections: [SearchSection] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: Methods
    private func update(with results: [SearchResult]) {
        let movies = results.filter({
            switch $0 {
            case .movie: return true
            default: return false
            }
        })
        let tvshows = results.filter({
            switch $0 {
            case .tv: return true
            default: return false
            }
        })
        let persons = results.filter({
            switch $0 {
            case .person: return true
            default: return false
            }
        })
        
        self.sections = [
        SearchSection(title: "Movies", result: movies),
        SearchSection(title: "TVShows", result: tvshows),
        SearchSection(title: "Persons", result: persons)
        ]
        
        DispatchQueue.main.async { 
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
    }
    
    // MARK: Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }

        APICaller.shared.getSearch(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let item):
                    self?.update(with: item)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - TableView Delegate & DataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].result[indexPath.row]
        
        switch result {
        case .movie(models: let movie):
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaSectionTableViewCell.identifier, for: indexPath) as! MediaSectionTableViewCell
            cell.configurate(model: movie)
            return cell
        case .tv(models: let tv):
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaSectionTableViewCell.identifier, for: indexPath) as! MediaSectionTableViewCell
            cell.configurate(model: tv)
            return cell
        case .person(persons: let person):
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaSectionTableViewCell.identifier, for: indexPath) as! MediaSectionTableViewCell
            cell.configurate(model: person)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
