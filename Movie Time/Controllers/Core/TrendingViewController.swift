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
    
    private var shouldPreventDisplayCellAnimation: Bool = true
    
    // MARK: - Model
    private var model = [TrendingViewModel]()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupTableViewCell()
    }
    
    // MARK: - Setup Table View
    private func setupTableViewCell() {
        // MARK: Configure Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        
        tableView.sectionFooterHeight = 0
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        tableView.tableFooterView = footerView
        
        // MARK: Registration Note Table View Cell
        tableView.register(NewMoviePosterTableViewCell.nib(), forCellReuseIdentifier: NewMoviePosterTableViewCell.identifier)
        tableView.register(TrendingTableViewHeader.self, forHeaderFooterViewReuseIdentifier: TrendingTableViewHeader.identifier)
        tableView.register(MediaSectionTableViewCell.nib(), forCellReuseIdentifier: MediaSectionTableViewCell.identifier)
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
                let popular = popularMovies,
                let upcoming = upcomingMovies
            else {
                return
            }
            
            self.configureModel(
                trending: trending.results,
                recommended: recommended.results,
                upcoming: upcoming.results,
                popular: popular.results
            )
        }
    }
    
    // MARK: - Prefetching data
    private func prefetchData(section: Int) {
        guard !model.isEmpty else { return }
        
        if model[section].section == .upcoming {
            model[section].isPaginating = true
            model[section].page += 1
            
            APICaller.shared.getUpcomingMovies(page: model[section].page) { [weak self] result in
                switch result {
                case .success(let movies):
                    if movies.results.count == 0 {
                        self?.model[section].isPaginating = true
                        self?.shouldPreventDisplayCellAnimation = true
                        return
                    }
                    self?.model[section].movie.append(contentsOf: movies.results)
                    self?.model[section].isPaginating = false
                    
                    DispatchQueue.main.async {
                        self?.shouldPreventDisplayCellAnimation = false
                        self?.tableView.reloadData()
                        
                        DispatchQueue.main.async {
                            self?.shouldPreventDisplayCellAnimation = true
                        }
                    }
                    
                case .failure(let error):
                    self?.model[3].isPaginating = true
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Configure Model
    private func configureModel(trending: [Movie], recommended: [Movie], upcoming: [Movie], popular: [Movie]) {
        // Create Now Trending Section
        model.append(TrendingViewModel(section: .nowTrending, movie: trending))
        
        // Create Latest Section
        model.append(TrendingViewModel(section: .recommended, movie: recommended))
        
        // Create Popular Section
        model.append(TrendingViewModel(section: .popular, movie: popular))
        
        // Create Upcomming Section
        model.append(TrendingViewModel(section: .upcoming, movie: upcoming))

        HapticManager.shared.vibrateForImpactFeedback()
        tableView.reloadData()
    }
    
    /// Embeds ViewController into NavigationController and present last one
    private func presentNavVC(vc: UIViewController) {
        vc.navigationItem.largeTitleDisplayMode = .always
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
        if section == 3 {
            return model[section].movie.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaSectionTableViewCell.identifier) as! MediaSectionTableViewCell
            cell.configurate(model: model[indexPath.section].movie.randomElement()!)
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaSectionTableViewCell.identifier) as! MediaSectionTableViewCell
            cell.configurate(model: model[indexPath.section].movie[indexPath.row])
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewMoviePosterTableViewCell.identifier, for: indexPath) as! NewMoviePosterTableViewCell
            cell.configure(model: model[indexPath.section].movie)
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1,3:
            return view.frame.height / 4
        default:
            return view.frame.height / 3
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TrendingTableViewHeader.identifier) as? TrendingTableViewHeader else {
            return UIView()
        }
        view.configure(title: model[section].section.rawValue)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard shouldPreventDisplayCellAnimation else { return }
        
        if indexPath.section == 3 {
            let transform = CATransform3DTranslate(CATransform3DIdentity, 0, Theme.padding, 0)
            cell.layer.transform = transform
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.5) {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1
            }
        }
    }
}

// MARK: - Prefetching Data Delegate
extension TrendingViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.row >= model[index.section].movie.count - 3 && !model[index.section].isPaginating {
                prefetchData(section: index.section)
            }
        }
    }
}

// MARK: - Set New Movie Poster Cell Delegate
extension TrendingViewController: NewMoviePosterTableViewCellDelegate {
    func didTapPoster(cellView: NewMoviePosterTableViewCell, model: Movie) {
        HapticManager.shared.vibrateForSelection()
        presentNavVC(vc: MovieViewController(media: model))
    }
}

// MARK: - Set New Media Section TableView Cell Delegate
extension TrendingViewController: MediaSectionTableViewCellDelegate {
    func didTapSectionCell(cellView: MediaSectionTableViewCell, mediaType: MediaType, model: Any) {
        switch mediaType {
        case .movie:
            guard let model = model as? Movie else { return }
            HapticManager.shared.vibrateForSelection()
            presentNavVC(vc: MovieViewController(media: model))
        case .tv:
            return
        }
    }
}
