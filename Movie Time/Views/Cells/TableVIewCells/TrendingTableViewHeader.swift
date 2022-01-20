//
//  TrendingTableViewHeader.swift
//  Movie Time
//
//  Created by Yury Kruk on 16.01.2022.
//

import UIKit

class TrendingTableViewHeader: UITableViewHeaderFooterView {
    // MARK: - Static Identifiers
    static let identifier = "TrendingTableViewHeader"
    
    // MARK: - Properties
    let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .light)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Configure Header
    public func configure(title: String) {
        self.title.text = title
    }
    
    // MARK: - Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = CGRect(x: Theme.padding, y: 0, width: contentView.bounds.width - Theme.padding, height: contentView.bounds.height)
    }
    
    // MARK: - Header Life Cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.title.text = nil
    }
}
