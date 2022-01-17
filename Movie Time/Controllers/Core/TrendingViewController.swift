//
//  TrendingViewController.swift
//  Movie Time
//
//  Created by Yury Kruk on 08.12.2021.
//

import UIKit

class TrendingViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet var tableView: UITableView! {
        didSet {
            // MARK: Configure Table View
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            
            // MARK: Registration Note Table View Cell
            tableView.register(NewMoviePosterTableViewCell.nib(),
                               forCellReuseIdentifier: NewMoviePosterTableViewCell.identifier)
            tableView.register(TrendingTableViewHeader.self,
                               forHeaderFooterViewReuseIdentifier: TrendingTableViewHeader.identifier)
        }
    }
    
    // MARK: - Mock Model
    private var model = [TrendingViewModel]()
    func setupMockModel() {
        let movies = [
            Movie(poster: UIImage(named: "movie1")!, name: "Euphoria", description: "", releaseDate: "2022", duration: 45, rating: 81),
            Movie(poster: UIImage(named: "movie3")!, name: "Spiderman: No way home", description: "", releaseDate: "2022", duration: 145, rating: 87),
            Movie(poster: UIImage(named: "movie2")!, name: "Boba Fet", description: "", releaseDate: "2022", duration: 41, rating: 78),
            Movie(poster: UIImage(named: "movie4")!, name: "Eternals", description: "", releaseDate: "2021", duration: 128, rating: 67)
        ]
        model.append(TrendingViewModel(section: "New Releases", movie: movies.shuffled()))
        model.append(TrendingViewModel(section: "Popular now", movie: movies.shuffled()))
        model.append(TrendingViewModel(section: "Coming Soon", movie: movies.shuffled()))
    }
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMockModel()
    }
}

// MARK: - Set Table View Data Source & Delegate
extension TrendingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewMoviePosterTableViewCell.identifier, for: indexPath) as! NewMoviePosterTableViewCell
        cell.configure(model: model[indexPath.section].movie)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TrendingTableViewHeader.identifier) as? TrendingTableViewHeader else {
            return UIView()
        }
        view.configure(title: model[section].section)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

// MARK: - Set New Movie Poster Cell Delegate
extension TrendingViewController: NewMoviePosterTableViewCellDelegate {
    func didTapPoster(cellView: NewMoviePosterTableViewCell, model: Movie) {
        let vc = UIViewController()
        vc.navigationItem.largeTitleDisplayMode = .always
        vc.view.backgroundColor = .systemGray
        vc.title = model.name
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .formSheet
        present(navVC, animated: true, completion: nil)
    }
}
