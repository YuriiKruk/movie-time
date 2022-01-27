//
//  TrendingTableViewHeader.swift
//  Movie Time
//
//  Created by Yury Kruk on 16.01.2022.
//

import UIKit

class TrendingTableViewHeader: UITableViewHeaderFooterView, NibSetapable {
    
    // MARK: - Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .light)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.padding).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Theme.padding).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return label
    }()
    
    // MARK: - Configure Header
    public func configure(title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    deinit {
        print("❌❌❌ TrendingTableViewHeader deinited ")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }
}
