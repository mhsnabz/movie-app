//
//  SeeAllViewModel.swift
//  MovieApp
//
//  Created by srbrt on 10.02.2024.
//

import Moya
import RxSwift
/// ViewModel responsible for fetching and managing movie data for a see-all screen.
final class SeeAllViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private var listDisposable: Disposable?
    private var loadMoreDisposable: Disposable?

    private var list: PublishSubject<MovieListModel> = PublishSubject()
    private var isDone: PublishSubject<Bool> = PublishSubject()

    private var dataSource: [Result] = []
    private var isLoadingMore: Bool = false
    var currentPage: Int = 1

    override init() {
        super.init()
    }

    /// Cancels ongoing network requests.
    func cancelRequest() {
        // Disposes the disposable associated with ongoing network requests if any.
        listDisposable?.dispose()
    }

    /// Returns whether the ViewModel is currently loading more items.
    func isLoadingMoreItem() -> Bool {
        isLoadingMore
    }

    /// Sets the loading state for more items.
    func setIsLoadingMore(isLoading: Bool) {
        isLoadingMore = isLoading
    }

    /// Increments the current page number.
    func raiseCurrentPage() {
        currentPage += 1
    }

    /// Decreases the current page number.
    func incaresCurrentPage() {
        currentPage -= 1
        currentPage = abs(currentPage)
    }

    /// Returns the current data source.
    func getDataSource() -> [Result] {
        dataSource
    }

    /**
      Sets up the data source and fetches movie data based on the provided parameters.

      - Parameters:
         - genre: Optional genre title to filter movies.
         - section: Optional section type to fetch movies from.
         - page: The page number to fetch.
         - isLoadingMore: Indicates whether loading more movies.
         - similarMovies: Optional movie ID to fetch similar movies.

      - Returns: A PublishSubject indicating when the data fetching operation is done.
     */
    func setupDataSource(genre: GenreTitle? = nil, section: MovieSectionType? = nil, page: Int, isLoadingMore: Bool = false, similarMovies: Int? = nil) -> PublishSubject<Bool>? {
        isLoading.onNext(isLoadingMore ? false : true)

        // Depending on the parameters provided, different API requests are made.
        // Each request updates the data source with the fetched results.

        /// Fetches similar movies if the user wants to see similar movies in SeeAllViewController.
        if let similarMovies = similarMovies {
            listDisposable = getSimilarList(page: page, movieId: similarMovies).subscribe { [weak self] event in
                if let element = event.element, let result = element.results {
                    // Appends the fetched results to the data source.
                    self?.dataSource.append(contentsOf: result)
                    // Notifies observers that the operation is done.
                    self?.isDone.onNext(true)
                    // Raises the current page number for potential pagination.
                    self?.raiseCurrentPage()
                } else if let error = event.error {
                    // Notifies observers if there's an error during the operation.
                    self?.isDone.onError(error)
                }
            }
            /// Filters movies by genre and section if provided.
        } else if let genre = genre, let section = section, genre != .all {
            listDisposable = filterByGenre(page: page, section: section, genre: genre).subscribe { [weak self] event in
                if let element = event.element, let result = element.results {
                    // Appends the fetched results to the data source.
                    self?.dataSource.append(contentsOf: result)
                    // Notifies observers that the operation is done.
                    self?.isDone.onNext(true)
                    // Raises the current page number for potential pagination.
                    self?.raiseCurrentPage()
                } else if let error = event.error {
                    // Notifies observers if there's an error during the operation.
                    self?.isDone.onError(error)
                }
            }
            /// Fetches all movies based on the specified section.
        } else if let section = section {
            listDisposable = getMovieLists(page: page, section: section).subscribe { [weak self] event in
                if let element = event.element, let result = element.results {
                    // Appends the fetched results to the data source.
                    self?.dataSource.append(contentsOf: result)
                    // Notifies observers that the operation is done.
                    self?.isDone.onNext(true)
                    // Raises the current page number for potential pagination.
                    self?.raiseCurrentPage()
                } else if let error = event.error {
                    // Notifies observers if there's an error during the operation.
                    self?.isDone.onError(error)
                }
            }
        }

        // Returns the subject that indicates when the operation is done.
        return isDone
    }

    /// Fetches a list of similar movies.
    private func getSimilarList(page: Int, movieId: Int) -> PublishSubject<MovieListModel> {
        let disposable = movieListProvider.rx.request(.getSimilarMovies(page: page, movieId: movieId)).observe(on: MainScheduler.instance)
            .map(MovieListModel.self)
            .subscribe(onSuccess: { response in
                self.list.onNext(response)
                self.isLoading.onNext(false)
            }, onFailure: { error in
                self.list.onError(error)
                self.isLoading.onNext(false)
            })
        disposable.disposed(by: disposeBag)
        return list
    }

    /// Fetches a list of movies based on a specific section type. like  Now Playing , Top Rated
    private func getMovieLists(page: Int, section: MovieSectionType) -> PublishSubject<MovieListModel> {
        var request: MovieList = .getPopular(page: page)
        switch section {
        case .nowPlaying: request = .nowPlaying(page: page)
        case .popular: request = .getPopular(page: page)
        case .topRated: request = .getTopRated(page: page)
        case .upcoming: request = .upcoming(page: page)
        }

        let disposable = MovieApp.movieListProvider.rx.request(request)
            .observe(on: MainScheduler.instance)
            .map(MovieListModel.self)
            .subscribe(onSuccess: { response in
                // When the request is successful, the obtained response is emitted to the `list` subject,
                // and the loading state is updated to false.
                self.list.onNext(response)
                self.isLoading.onNext(false)
            }, onFailure: { error in
                // When the request fails, the error is emitted to the `list` subject,
                // and the loading state is updated to false.
                self.list.onError(error)
                self.isLoading.onNext(false)
            })

        // Dispose the disposable when it's no longer needed to prevent memory leaks.
        disposable.disposed(by: disposeBag)

        return list
    }

    /// Fetches a list of movies filtered by genre and section type.
    private func filterByGenre(page: Int, section: MovieSectionType, genre: GenreTitle) -> PublishSubject<MovieListModel> {
        let genres = [genre]
        var request: MovieList = .getSortedMovies(genres: genres, sortyBy: .relase_date_desc, date: "2024-01-01", page: page)
        switch section {
        case .nowPlaying: request = .getSortedMovies(genres: genres, sortyBy: .relase_date_desc, date: "2024-01-01", page: page)
        case .popular: request = .getSortedMovies(genres: genres, sortyBy: .popular_desc, page: page)
        case .topRated: request = .getSortedMovies(genres: genres, sortyBy: .vote_desc, page: page)
        case .upcoming: request = .getSortedMovies(genres: genres, sortyBy: .relase_date_desc, date: "2024-03-01")
        }

        let disposable = MovieApp.movieListProvider.rx.request(request)
            .observe(on: MainScheduler.instance)
            .map(MovieListModel.self)
            .subscribe(onSuccess: { response in
                self.list.onNext(response)
                self.isLoading.onNext(false)
            }, onFailure: { error in
                self.list.onError(error)
                self.isLoading.onNext(false)
            })

        disposable.disposed(by: disposeBag)

        return list
    }
}

/// Enum representing different sections of movies.
enum MovieSectionType: Int {
    case nowPlaying
    case popular
    case topRated
    case upcoming
}
