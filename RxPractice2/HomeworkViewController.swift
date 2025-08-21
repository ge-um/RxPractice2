//
//  HomeworkViewController.swift
//  RxSwift
//
//  Created by Jack on 1/30/25.
//

import SnapKit
import RxCocoa
import RxSwift
import UIKit
import Kingfisher

class HomeworkViewController: UIViewController {
    let tableView = UITableView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
    
    private let viewModel = HomeworkViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
     
    private func bind() {
        let input = HomeworkViewModel.Input(
            modelSelected: tableView.rx.modelSelected(Person.self),
            searchText: searchBar.rx.text.orEmpty,
            searchButtonClick: searchBar.rx.searchButtonClicked
        )
        let output = viewModel.transform(input: input)
        
        output.items.bind(to: tableView.rx.items(cellIdentifier: PersonTableViewCell.identifier, cellType: PersonTableViewCell.self)) { row, element, cell in
            cell.configure(with: element)

            cell.detailButton.rx.tap
                .map { element }
                .bind(with: self) { owner, person in
                    let vc = UIViewController()
                    vc.view.backgroundColor = .white
                    vc.navigationItem.title = element.name
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
                .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
        
        output.selectedItems
            .bind(to: collectionView.rx.items(
                cellIdentifier: UserCollectionViewCell.identifier,
                cellType: UserCollectionViewCell.self
            )) { row, item, cell in
                cell.label.text = item.name
            }
            .disposed(by: disposeBag)

    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
         
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}
 
