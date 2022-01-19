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
    
    // MARK: - Model
    private var model = [TrendingViewModel]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    // MARK: - Fetch Data
    private func fetchData() {
        let group = DispatchGroup()
        
        var trending: Trending?
        
        // MARK: Get Trending Movies
        group.enter()
        APICaller.shared.getTrendingMovies(mediaType: .movie, timeWindow: .day) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let data):
                trending = data
            case .failure(let error):
                print(error)
            }
        }
        
        // MARK: Configure model
        group.notify(queue: .main) {
            guard let trending = trending else {
                return
            }
            
            self.configureModel(trending: trending.results)
        }
    }
    
    private func configureModel(trending: [Movie]) {
        model.append(TrendingViewModel(section: "Now Trending", movie: trending))
        
        tableView.reloadData()
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
        vc.title = model.title
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .formSheet
        present(navVC, animated: true, completion: nil)
    }
}
