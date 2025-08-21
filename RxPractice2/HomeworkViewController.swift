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
    
    private lazy var items = BehaviorSubject<[Person]>(value: Person.sampleUsers)
    private let selectedItems = BehaviorSubject<[String]>(value: [])
    
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
     
    private func bind() {
        items.bind(to: tableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier) as! PersonTableViewCell
            cell.usernameLabel.text = element.name
            
            guard let url = URL(string: element.profileImage) else { return UITableViewCell() }
            cell.profileImageView.kf.setImage(with: url)
            
            cell.detailButton.rx.tap
                .bind(with: self) { owner, _ in
                    let vc = UIViewController()
                    vc.view.backgroundColor = .white
                    vc.navigationItem.title = element.name
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
                .disposed(by: cell.disposeBag)
            
            return cell
        }
        .disposed(by: disposeBag)
        
        selectedItems
            .bind(to: collectionView.rx.items(
                cellIdentifier: UserCollectionViewCell.identifier,
                cellType: UserCollectionViewCell.self
            )) { row, item, cell in
                cell.label.text = item
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(Person.self)
            .subscribe(with: self) { owner, value in
                var all = try! owner.selectedItems.value()
                all.append(value.name)
                owner.selectedItems.onNext(all)
                print(all)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .subscribe(with: self) { owner, _ in
                var all = try! owner.items.value()
                
                let person = Person(name: owner.searchBar.text!, email: "ddd@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/26.jpg")
                all.append(person)
                owner.items.onNext(all)
                
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
 
