//
//  TrendingViewController.swift
//  Movie Time
//
//  Created by Yury Kruk on 08.12.2021.
//

import UIKit

class TrendingViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Model
    private var model = [TrendingViewModel]()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupTableViewCell()
    }

    private func setupTableViewCell() {
        // MARK: Configure Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        
        // MARK: Registration Note Table View Cell
        tableView.register(NewMoviePosterTableViewCell.nib(),
                           forCellReuseIdentifier: NewMoviePosterTableViewCell.identifier)
        tableView.register(TrendingTableViewHeader.self,
                           forHeaderFooterViewReuseIdentifier: TrendingTableViewHeader.identifier)
        tableView.register(MovieSectionTableViewCell.nib(), forCellReuseIdentifier: MovieSectionTableViewCell.identifier)
    }
    
    // MARK: - Fetch Data
    private func fetchData() {
        let group = DispatchGroup()
        
        var trendingMovies: MovieObject?
        var recommendedMovie: MovieObject?
        var upcomingMovies: MovieObject?
        var popularMovies: MovieObject?
        
        // MARK: Get Trending Movies
        group.enter()
        APICaller.shared.getTrendingMovies(mediaType: .movie, timeWindow: .day) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let data):
                trendingMovies = data
            case .failure(let error):
                print(error)
            }
        }
        
        // MARK: Get Recommended Movie
        group.enter()
        APICaller.shared.getTopRatedMovies { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let data):
                recommendedMovie = data
            case .failure(let error):
                print(error)
            }
        }
        
        // MARK: Get Upcoming Movies
        group.enter()
        APICaller.shared.getUpcomingMovies { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let data):
                upcomingMovies = data
            case .failure(let error):
                print(error)
            }
        }
        
        // MARK: Get Now Playing Movies
        group.enter()
        APICaller.shared.getPopularMovies { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let data):
                popularMovies = data
            case .failure(let error):
                print(error)
            }
        }
        
        // MARK: Configure model
        group.notify(queue: .main) {
            guard
                let trending = trendingMovies,
                let recommended = recommendedMovie,
                let nowPlaying = popularMovies,
                let upcoming = upcomingMovies
            else {
                return
            }
            
            self.configureModel(
                trending: trending.results,
                recommended: recommended.results,
                upcoming: upcoming.results,
                nowPlaying: nowPlaying.results
            )
        }
    }
    
    private func configureModel(trending: [Movie], recommended: [Movie], upcoming: [Movie], nowPlaying: [Movie]) {
        // MARK: Create Now Trending Section
        model.append(TrendingViewModel(section: "Now Trending", movie: trending))
        
        // MARK: Create Latest Section
        model.append(TrendingViewModel(section: "Recommended", movie: recommended))
        
        // MARK: Create Upcomming Section
        model.append(TrendingViewModel(section: "Upcoming", movie: upcoming))
        
        // MARK: Create Now Playing Section
        model.append(TrendingViewModel(section: "Popular", movie: nowPlaying))
        
        tableView.reloadData()
    }
    
    /// Embeds ViewController into NavigationController and present last one
    private func presentNavVC(vc: UIViewController, title: String) {
        vc.navigationItem.largeTitleDisplayMode = .always
        vc.title = title
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .formSheet
        present(navVC, animated: true, completion: nil)
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
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieSectionTableViewCell.identifier) as! MovieSectionTableViewCell
            cell.configurate(model: model[indexPath.section].movie.randomElement()!)
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: NewMoviePosterTableViewCell.identifier, for: indexPath) as! NewMoviePosterTableViewCell
        cell.configure(model: model[indexPath.section].movie)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return view.frame.height / 4
        }
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
        presentNavVC(vc: MovieViewController(media: model), title: model.title)
    }
}

extension TrendingViewController: MovieSectionTableViewCellDelegate {
    func didTapSectionCell(model: Movie) {
        presentNavVC(vc: MovieViewController(media: model), title: model.title)
    }
}
