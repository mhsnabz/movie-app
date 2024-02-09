//
//  DiscoverViewModel.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import RxSwift
final class DiscoverViewModel : BaseViewModel{
    private let disposeBag = DisposeBag()
    private var list : PublishSubject<[MovieListModel]>?
    private var isDone : PublishSubject<Bool> = PublishSubject()
    private var dataSource = [MovieListModel]()
    private var regularDataSource = [MovieListModel]()
    private var filtredDataSource = [MovieListModel]()
    private var genresModel = [Genre]()
    private var genresDataSource = [GenreTitle]()
    private var updateUI : PublishSubject<Bool> = PublishSubject()
    
    var isFiltred : Bool = false
    
    var seletedGenre : GenreTitle = .all
    override init() {
        super.init()
        setGenreDataSource()
    }
    
    func setupDataSource() -> PublishSubject<(Bool)>?{
        isLoading.onNext(true)

        getMovieLists().subscribe { list in
            if let list = list.element{
                self.dataSource = list
                self.regularDataSource = list
                self.isDone.onNext(true)
            }else if let error = list.error{
                self.isDone.onError(error)
            }
        }.disposed(by: self.disposeBag)
        return isDone
    }
    
    func getNumberSection() -> Int{
        return  isFiltred ? filtredDataSource.count : regularDataSource.count
    }
    
    func getSection(section : Int) -> MovieListModel{
        return isFiltred ? filtredDataSource[section] : regularDataSource[section]
    }
    
 
    private func setGenreDataSource(){
        genresDataSource = self.getGenresDataSource()
    }
    
    private func getGenres(){
        if let data =  self.getLocalJson(resource: "genre") ,  let genre = data.genres{
            self.genresModel = genre
        }
    }
    
    private func getMovieLists() -> PublishSubject<[MovieListModel]> {
        list = PublishSubject()
        let nowPlaying = movieListProvider.rx.request(.nowPlayin(page: 1)).map(MovieListModel.self).asObservable()
        let popularRequest = movieListProvider.rx.request(.getPopular(page: 1)).map(MovieListModel.self).asObservable()
        let topRatedRequest = movieListProvider.rx.request(.getTopRated(page: 1)).map(MovieListModel.self).asObservable()
        let upcomingRequest = movieListProvider.rx.request(.upcoming(page: 1)).map(MovieListModel.self).asObservable()
        
        Observable.zip(nowPlaying,popularRequest, topRatedRequest, upcomingRequest)
            .observe(on: MainScheduler.instance)
            .subscribe {[weak self] event in
                switch event {
                case .next(let responses):
                    self?.dataSource =  Array<MovieListModel>(mirrorChildValuesOf: responses) ?? []
                    self?.isLoading.onNext(false)
                    self?.list?.onNext(self?.dataSource ?? [])
                case .error(let error):
                    self?.list?.onError(error)
                    self?.isLoading.onNext(false)
                default:
                    break
                }
            }
            .disposed(by: self.disposeBag)
        return list!
    }
    
     func getGenresSource() -> [GenreTitle] {
        return self.genresDataSource
     }
    
    func filterResultsByGenre(_ genreID: GenreTitle, completion : @escaping(_ isDone : Bool) ->()){
        self.isFiltred = self.seletedGenre != genreID && genreID.id != 0 ? true : false
        self.seletedGenre = genreID
        self.filtredDataSource.removeAll()
        for (index, movieListModel) in dataSource.enumerated() {
            let filtred = movieListModel.results?.filter({$0.genreIDS != nil && $0.genreIDS!.contains({genreID.id}())})
            self.filtredDataSource.append(MovieListModel(dates: dataSource[index].dates, page: dataSource[index].page, results: filtred, totalPages: dataSource[index].totalPages, totalResults: dataSource[index].totalResults))
        }
        completion(true)
    }
}
extension Array {
  init?<Subject>(mirrorChildValuesOf subject: Subject) {
    guard let array = Mirror(reflecting: subject).children.map(\.value) as? Self
    else { return nil }

    self = array
  }
}
