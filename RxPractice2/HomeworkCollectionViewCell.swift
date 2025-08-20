//
//  HomeworkCollectionViewCell.swift
//  RxPractice2
//
//  Created by 금가경 on 8/20/25.
//

import SnapKit
import UIKit

final class HomeworkCollectionViewCell: UICollectionViewCell {
    static var identifier: String {
        String(describing: Self.self)
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Mike"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    private func setUpUI() {
        var config = UIBackgroundConfiguration.clear()
        config.backgroundColor = .gray
        config.cornerRadius = 10
        config.strokeColor = .black
        config.strokeWidth = 1
        backgroundConfiguration = config
        
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
