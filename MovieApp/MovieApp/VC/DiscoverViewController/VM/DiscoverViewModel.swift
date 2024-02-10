//
//  DiscoverViewModel.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import RxSwift

final class DiscoverViewModel: BaseViewModel {
    // Dispose bag for managing disposables
    private let disposeBag = DisposeBag()

    // Subject for emitting movie lists
    private var list: PublishSubject<[MovieListModel]>?

    // Subject for indicating if the API requests are completed
    private var isDone: PublishSubject<Bool> = PublishSubject()

    // Data sources for movie lists
    private var dataSource = [MovieListModel]()

    // Data source for genres
    private var genresModel = [Genre]()
    private var genresDataSource = [GenreTitle]()

    // Subject for updating UI
    private var updateUI: PublishSubject<Bool> = PublishSubject()

 
    // Selected genre
    var selectedGenre: GenreTitle = .all

    override init() {
        super.init()
        setGenreDataSource()
    }

    // Setup data source by making API calls
    func setupDataSource(genre : GenreTitle? = nil ) -> PublishSubject<Bool>? {
        
        isLoading.onNext(true)
        if  let genre , genre != .all  {
            filterByGenre(genre: genre).subscribe { list in
                if let list = list.element {
                    self.dataSource.removeAll()
                    self.dataSource = list
                    self.isDone.onNext(true)
                } else if let error = list.error {
                    self.isDone.onError(error)
                }
            }.disposed(by: disposeBag)
        }else{
            getMovieLists().subscribe { list in
                if let list = list.element {
                    self.dataSource.removeAll()
                    self.dataSource = list
                    self.isDone.onNext(true)
                } else if let error = list.error {
                    self.isDone.onError(error)
                }
            }.disposed(by: disposeBag)
        }
        
        return isDone
    }

    func filterByGenre(genre : GenreTitle) -> PublishSubject<[MovieListModel]> {
        let genres = [genre]
        list = PublishSubject()
        // Make API requests to fetch different categories of movie lists
        let nowPlaying = movieListProvider.rx.request(.getSortedMovies(genres: genres, sortyBy: .relase_date_desc,date: "2024-01-01")).map(MovieListModel.self).asObservable()
        
        let popularRequest = movieListProvider.rx.request(.getSortedMovies(genres: genres, sortyBy: .popular_desc)).map(MovieListModel.self).asObservable()
        let topRatedRequest = movieListProvider.rx.request(.getSortedMovies(genres: genres, sortyBy: .vote_desc)).map(MovieListModel.self).asObservable()
        let upcomingRequest = movieListProvider.rx.request(.getSortedMovies(genres: genres, sortyBy: .relase_date_desc,date: "2024-03-01")).map(MovieListModel.self).asObservable()
        
        // Combine the responses of all requests into a single observable
        Observable.zip(nowPlaying, popularRequest, topRatedRequest, upcomingRequest)
            .observe(on: MainScheduler.instance) // Ensure subscription and observation happen on the main thread
            .subscribe { [weak self] event in
                switch event {
                case let .next(responses):
                    // When responses are received, convert them into an array of MovieListModel objects
                    self?.dataSource = [MovieListModel](mirrorChildValuesOf: responses) ?? []

                    // Notify that loading is complete and emit the movie lists
                    self?.isLoading.onNext(false)
                    self?.list?.onNext(self?.dataSource ?? [])

                case let .error(error):
                    // Handle any errors by notifying and emitting them
                    self?.list?.onError(error)
                    self?.isLoading.onNext(false)

                default:
                    self?.isLoading.onNext(false)
                }
            }
            .disposed(by: disposeBag) // Dispose subscriptions when the view model is deallocated
        
        // Return the PublishSubject
        return list!
    }
    
    
    // Get the number of sections based on whether results are filtered
    func getNumberOfSections() -> Int {
        return dataSource.count
    }

    // Get the section based on the index and whether results are filtered
    func getSection(section: Int) -> MovieListModel {
        return dataSource[section]
    }

    // Set up the data source for genres
    private func setGenreDataSource() {
        genresDataSource = getGenresDataSource()
    }

    // Get genres from local JSON file
    private func getGenres() {
        if let data = getLocalJson(resource: "genre"), let genre = data.genres {
            genresModel = genre
        }
    }

    private func getMovieLists() -> PublishSubject<[MovieListModel]> {
        // Initialize a PublishSubject to emit movie lists
        list = PublishSubject()

        // Make API requests to fetch different categories of movie lists
        let nowPlaying = movieListProvider.rx.request(.nowPlaying(page: 1)).map(MovieListModel.self).asObservable()
        let popularRequest = movieListProvider.rx.request(.getPopular(page: 1)).map(MovieListModel.self).asObservable()
        let topRatedRequest = movieListProvider.rx.request(.getTopRated(page: 1)).map(MovieListModel.self).asObservable()
        let upcomingRequest = movieListProvider.rx.request(.upcoming(page: 1)).map(MovieListModel.self).asObservable()

        // Combine the responses of all requests into a single observable
        Observable.zip(nowPlaying, popularRequest, topRatedRequest, upcomingRequest)
            .observe(on: MainScheduler.instance) // Ensure subscription and observation happen on the main thread
            .subscribe { [weak self] event in
                switch event {
                case let .next(responses):
                    // When responses are received, convert them into an array of MovieListModel objects
                    self?.dataSource = [MovieListModel](mirrorChildValuesOf: responses) ?? []

                    // Notify that loading is complete and emit the movie lists
                    self?.isLoading.onNext(false)
                    self?.list?.onNext(self?.dataSource ?? [])

                case let .error(error):
                    // Handle any errors by notifying and emitting them
                    self?.list?.onError(error)
                    self?.isLoading.onNext(false)

                default:
                    self?.isLoading.onNext(false)
                }
            }
            .disposed(by: disposeBag) // Dispose subscriptions when the view model is deallocated

        // Return the PublishSubject
        return list!
    }

    // Get genres data source
    func getGenresSource() -> [GenreTitle] {
        return genresDataSource
    }

   
    // Filter results by genre
   // func filterResultsByGenre(_ genreID: GenreTitle, completion: @escaping (_ isDone: Bool) -> Void) {
   //     isFiltered = selectedGenre != genreID && genreID.id != 0 ? true : false
   //     selectedGenre = genreID
   //     filteredDataSource.removeAll()
   //     for (index, movieListModel) in dataSource.enumerated() {
   //         let filtered = movieListModel.results?.filter { $0.genreIDS != nil && //$0.genreIDS!.contains(genreID.id) }
   //         filteredDataSource.append(MovieListModel(dates: dataSource[index].dates, page: //dataSource[index].page, results: filtered, totalPages: dataSource[index].totalPages, //totalResults: dataSource[index].totalResults))
   //     }
   //     completion(true)
   // }
}

// Extension for initializing an array from a subject's child values
extension Array {
    init?<Subject>(mirrorChildValuesOf subject: Subject) {
        guard let array = Mirror(reflecting: subject).children.map(\.value) as? Self else { return nil }
        self = array
    }
}
