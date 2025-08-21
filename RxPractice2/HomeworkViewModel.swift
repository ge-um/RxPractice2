//
//  HomeViewModel.swift
//  RxPractice2
//
//  Created by 금가경 on 8/22/25.
//

import Foundation
import RxCocoa
import RxSwift

final class HomeworkViewModel {
    struct Input {
        let modelSelected: ControlEvent<Person>
        let searchText: ControlProperty<String>
        let searchButtonClick: ControlEvent<Void>
    }
    
    struct Output {
        let items: BehaviorSubject<[Person]>
        let selectedItems: BehaviorSubject<[Person]>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let items = BehaviorSubject(value: Person.sampleUsers)
        let selectedItems = BehaviorSubject<[Person]>(value: [])
        
        input.modelSelected
            .withLatestFrom(selectedItems) { new, selectedItems in
                selectedItems + [new]
            }
            .bind(to: selectedItems)
            .disposed(by: disposeBag)

        input.searchButtonClick
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map { Person(name: $0, email: "ddd@example.com", profileImage: "https://randomuser.me/api/portraits/thumb/men/26.jpg") }
            .withLatestFrom(items) { new, items in
                items + [new]
            }
            .bind(to: items)
            .disposed(by: disposeBag)
        
        return Output(items: items, selectedItems: selectedItems)
    }
}
