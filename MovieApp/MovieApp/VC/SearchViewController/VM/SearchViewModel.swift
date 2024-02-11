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
        // Subscribing to the observable sequence returned by `getSearchResult` and setting up the data source.
        listDisposable = getSearchResult(query: query).subscribe { [weak self] event in
            // Checking if the event element exists and contains search results.
            if let element = event.element, let result = element.results {
                // If search results are obtained:
                // Updating the data source with the fetched results.
                self?.dataSource = result
                // Signaling that the data source setup is complete by emitting a value through the `isDone` subject.
                self?.isDone.onNext(true)
            } else if let error = event.error {
                // If an error occurs during the data source setup:
                // Signaling the error by emitting it through the `isDone` subject.
                self?.isDone.onError(error)
                self?.alertSubject.onNext(error.localizedDescription)
            }
        }
        // Returning the `isDone` subject to signal the completion or error of the data source setup.
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
