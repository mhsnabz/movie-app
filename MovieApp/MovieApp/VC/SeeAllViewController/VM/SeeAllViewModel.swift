//
//  SeeAllViewModel.swift
//  MovieApp
//
//  Created by srbrt on 10.02.2024.
//

import RxSwift
import Moya
final class SeeAllViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private var listDisposable: Disposable?
    private var loadMoreDisposable : Disposable?
    private var list: PublishSubject<MovieListModel> = PublishSubject()
    private var isDone: PublishSubject<Bool> = PublishSubject()

    private var dataSource: [Result] = []
    private var isLoadingMore : Bool = false
    var currentPage: Int = 1

    override init() {  super.init()  }
    
    func cancelRequest(){
        listDisposable?.dispose()
    }
    
    func isLoadingMoreItem() -> Bool{
        isLoadingMore
    }
    
    func setIsLoadingMore(isLoadig : Bool){
        isLoadingMore = isLoadig
    }
    
    func raiseCurrentPage(){
        self.currentPage += 1
    }
    
    func incaresCurrentPage(){
        self.currentPage -= 1
        self.currentPage = abs(currentPage)
    }

 
    func setupDataSource(genre : GenreTitle? = nil , section : MovieSectionType? = nil , page : Int , isLoadingMore : Bool = false,similarMovies : Int? = nil)  -> PublishSubject<Bool>? {
        
        isLoading.onNext( isLoadingMore ? false : true)
        if let similarMovies{
            listDisposable = getSimilarList(page: page,movieId: similarMovies).subscribe{[weak self] event in
                if let element = event.element , let result = element.results{
                    self?.dataSource.append(contentsOf: result)
                    self?.isDone.onNext(true)
                    self?.raiseCurrentPage()
                }else if let error = event.error{
                    self?.isDone.onError(error)
                }
            }
        }else if let genre , let section , genre != .all{
           
            listDisposable = filterByGenre(page: page, section: section, genre: genre).subscribe {[weak self] event in
                if let element = event.element , let result = element.results{
                    self?.dataSource.append(contentsOf: result)
                    self?.isDone.onNext(true)
                    self?.raiseCurrentPage()
                }else if let error = event.error{
                    self?.isDone.onError(error)
                }
            }
        }else if let section{
            listDisposable =  getMovieLists(page: page, section: section).subscribe {[weak self] event in
                if let element = event.element , let result = element.results{
                    self?.dataSource.append(contentsOf: result)
                    self?.isDone.onNext(true)
                    self?.raiseCurrentPage()
                }else if let error = event.error{
                    self?.isDone.onError(error)
                    print("error :\(error)")
                }
            }
        }
        return isDone
    }
    
    private func getSimilarList(page : Int, movieId : Int) -> PublishSubject<MovieListModel>{
        let disposable  = movieListProvider.rx.request(.getSimilarMovies(page: page,movieId: movieId)).observe(on: MainScheduler.instance)
            .map(MovieListModel.self)
            .subscribe(onSuccess: { response in
                // Handle response if needed
                self.list.onNext(response)
               // self.list.onCompleted()
                self.isLoading.onNext(false)
            }, onFailure: { error in
                self.list.onError(error)
                self.isLoading.onNext(false)
            })
        disposable.disposed(by: disposeBag)
        return list
    }
    
    private func getMovieLists(page : Int , section : MovieSectionType )   -> PublishSubject<MovieListModel>{
        var request : MovieList = .getPopular(page: page)
        switch section {
        case .nowPlaying: request = .nowPlaying(page: page)
        case .popular:  request = .getPopular(page: page)
        case .topRated:  request = .getTopRated(page: page)
        case .upcoming: request = .upcoming(page: page)
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
    
    private func filterByGenre(page : Int , section :MovieSectionType, genre : GenreTitle ) -> PublishSubject<MovieListModel>{
        let genres = [genre]
        var request : MovieList = .getSortedMovies(genres: genres, sortyBy: .relase_date_desc, date: "2024-01-01",page: page)
        switch section {
        case .nowPlaying: request = .getSortedMovies(genres: genres, sortyBy: .relase_date_desc, date: "2024-01-01",page: page)
        case .popular: request = .getSortedMovies(genres: genres, sortyBy: .popular_desc,page: page)
        case .topRated: request = .getSortedMovies(genres: genres, sortyBy: .vote_desc,page: page)
        case .upcoming: request = .getSortedMovies(genres: genres, sortyBy: .relase_date_desc, date: "2024-03-01")
        }
        
        
        let disposable = MovieApp.movieListProvider.rx.request(request)
                 .observe(on: MainScheduler.instance)
                 .map(MovieListModel.self)
                 .subscribe(onSuccess: { response in
                     // Handle response if needed
                     self.list.onNext(response)
                    // self.list.onCompleted()
                     self.isLoading.onNext(false)
                 }, onFailure: { error in
                     self.list.onError(error)
                     self.isLoading.onNext(false)
                 })
        
             disposable.disposed(by: disposeBag)
             
             return list
       
    }
    
    func getDataSource() -> [Result]{
        self.dataSource
    }
    
}

enum MovieSectionType : Int {
    case nowPlaying
    case popular
    case topRated
    case upcoming
}
