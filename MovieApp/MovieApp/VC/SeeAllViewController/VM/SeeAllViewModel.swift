//
//  SeeAllViewModel.swift
//  MovieApp
//
//  Created by srbrt on 10.02.2024.
//

import RxSwift
final class SeeAllViewModel : BaseViewModel{
    
    private let disposeBag = DisposeBag()
    private var list : PublishSubject<MovieListModel> = PublishSubject()
    private var dataSource : [Result] = []
    var currentPage : Int = 1
    
    override init() {
        super.init()
    }
    
    
    private func getMovies(type : MovieSectionType , genre : GenreTitle) -> PublishSubject<MovieListModel>{
        var selectedType = MovieList.getPopular(page: currentPage)
        switch type {
        case .nowPlaying:
            selectedType = MovieList.nowPlaying(page: currentPage)
        case .popular:
            selectedType = MovieList.getPopular(page: currentPage)
        case .topRated:
            selectedType = MovieList.getTopRated(page: currentPage)
        case .upcoming:
            selectedType = MovieList.upcoming(page: currentPage)
        }
        
        movieListProvider.rx.request(selectedType).observe(on: MainScheduler.instance)
            .map(MovieListModel.self)
            .subscribe { model in
                
            } onFailure: { error in
                
            }.disposed(by: self.disposeBag)
        
        
        return list
    }
    
   // private func filterMovieList(genre : GenreTitle , movies : MovieListModel ) {
   //     if let filtered = movies.results?.filter({$0.genreIDS != nil && $0.genreIDS!.contains(genre.id)}){
   //         self.dataSource.append(contentsOf: filtered)
   //         list.onNext(<#T##element: MovieListModel##MovieListModel#>)
   //     }
  //  }
    
}

enum MovieSectionType{
    case nowPlaying
    case popular
    case topRated
    case upcoming
}
