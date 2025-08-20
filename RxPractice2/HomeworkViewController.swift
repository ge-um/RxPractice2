//
//  HomeworkViewController.swift
//  RxPractice2
//
//  Created by 금가경 on 8/20/25.
//

import RxSwift
import RxCocoa
import SnapKit
import UIKit

class HomeworkViewController: UIViewController {
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.itemSize = .init(width: 100, height: 40)
        layout.sectionInset = .init(top: 4, left: 0, bottom: 4, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .gray
        collectionView.register(HomeworkCollectionViewCell.self, forCellWithReuseIdentifier: HomeworkCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .yellow
        return tableView
    }()
    
    let disposeBag = DisposeBag()
    
    private let items = BehaviorSubject(value: ["Steven", "Mike", "Emma", "James", "Lisa", "John", "Sarah"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bind()
    }
    
    private func setUpUI() {
        view.backgroundColor = .white

        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.height.equalTo(48)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        items
            .bind(to: collectionView.rx.items(cellIdentifier: HomeworkCollectionViewCell.identifier, cellType: HomeworkCollectionViewCell.self)) { row, item, cell in
                cell.label.text = item
            }
            .disposed(by: disposeBag)
    }
}
