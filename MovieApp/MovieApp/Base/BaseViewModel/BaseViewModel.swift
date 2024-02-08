//
//  BaseViewModel.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import RxSwift
class BaseViewModel {
    var isLoading : PublishSubject<Bool> = PublishSubject()
    
    init() { }
}
