//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by srbrt on 11.02.2024.
//

import RxSwift
final class SearchViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private var list: PublishSubject<MovieListModel> = PublishSubject()
    private var isDone: PublishSubject<Bool> = PublishSubject()
    private var listDisposable: Disposable?
    private var dataSource: [Result] = []
    override init() {
        super.init()
    }

    func cancelRequest() {
        listDisposable?.dispose()
    }

    func getDataSource() -> [Result] {
        dataSource
    }

    func clearDataSource() {
        dataSource.removeAll()
    }

    func setupDataSource(query: String) -> PublishSubject<Bool> {
        listDisposable = getSearchResult(query: query).subscribe { [weak self] event in
            if let element = event.element, let result = element.results {
                self?.dataSource = result
                self?.isDone.onNext(true)
            } else if let error = event.error {
                self?.isDone.onError(error)
            }
        }
        return isDone
    }

    private func getSearchResult(query: String) -> PublishSubject<MovieListModel> {
        let disposable = movieListProvider.rx.request(.search(query: query))
            .observe(on: MainScheduler.instance)
            .map(MovieListModel.self)
            .subscribe(onSuccess: { response in
                self.list.onNext(response)
            }, onFailure: { error in
                self.list.onError(error)
            })

        disposable.disposed(by: disposeBag)

        return list
    }
}
