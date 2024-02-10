//
//  DetailViewModel.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import RxSwift
final class DetailViewModel : BaseViewModel{
    private let disposeBag = DisposeBag()
    private var detailSubject : PublishSubject<(DetailModel , MoviePosterModel)> = PublishSubject()
    private var imagesSource : MoviePosterModel?
     var detailSource : DetailModel?
    private var isDone: PublishSubject<Bool> = PublishSubject()
    private var cast = [Cast]()
    private var headerDataSource = [DetailHeaderModel]()
    private var similarDataSource = [SimilarResult]()
    override init() {
        super.init()
    }
    
    private func setupSimilarDataSource(){
        if let similar = detailSource?.similar , let results = similar.results?.prefix(10).sorted(by: {$0.voteAverage ?? 0 > $1.voteAverage ?? 0}){
            self.similarDataSource = results
        }
    }
    
    private func setupCastindDataSource(){
         if let cast = detailSource?.credits?.cast{
             self.cast = cast.filter({$0.knownForDepartment?.rawValue ?? "" == "Acting"}).prefix(8).sorted(by: {$0.popularity ?? 0 > $1.popularity ?? 0})
         }
     }
    
    private func setupHeaderDataSource(){
        if let imagesSource , let backdrops = imagesSource.backdrops{
            let avaibleImages = backdrops.filter({$0.aspectRatio ?? 0 > 15 / 9}).sorted(by: {$0.voteAverage ?? 0 > $1.voteAverage ?? 0}).prefix(4)
            avaibleImages.forEach { backdrops in
                headerDataSource.append(DetailHeaderModel(sourcePath: backdrops.filePath, type: .image))
            }
        }
        
        if  let officailVideo = detailSource?.videos {
            let video = officailVideo.results?.filter({$0.official == true && $0.type == "Teaser" && $0.site?.rawValue ?? "" == Site.youTube.rawValue}).first
            headerDataSource.append(DetailHeaderModel(sourcePath: video?.key, type: .video))
        }
        self.isDone.onNext(true)
    }
    
 
    
    func loadDetail(id : Int) -> PublishSubject<Bool>{
        isLoading.onNext(true)
        getDetail(id: id)?.subscribe(onNext: { (datail, images) in
            self.imagesSource = images
            self.detailSource = datail
            self.setupSimilarDataSource()
            self.setupCastindDataSource()
            self.setupHeaderDataSource()
        },onError: { error in
            self.isDone.onError(error)
        }).disposed(by: self.disposeBag)
        return isDone
    }
    
    func getHeaderDataSource() -> [DetailHeaderModel]{
        return headerDataSource
    }
    
    func getCastDataSource() -> [Cast]{
        return self.cast
    }
    
    func getSimilarDataSource() -> [SimilarResult]{
        return self.similarDataSource
    }
    
    
   private func getDetail(id : Int) -> PublishSubject<(DetailModel , MoviePosterModel)>?{
        let movieDetail = detailProvider.rx.request(.getDetail(id: id)).map(DetailModel.self).asObservable()
        let movieImages = detailProvider.rx.request(.getImages(id: id)).map(MoviePosterModel.self).asObservable()
        
        Observable.zip(movieDetail,movieImages)
            .observe(on: MainScheduler.instance)
            .subscribe {[weak self] elements in
                switch elements {
                case let .next(response):
                    self?.isLoading.onNext(false)
                    self?.detailSubject.onNext(response)
                    break
                case let .error(error):
                    self?.isLoading.onNext(false)
                    self?.detailSubject.onError(error)
                    break
                default : 
                    self?.isLoading.onNext(false)
                    break
                }
            }.disposed(by: self.disposeBag)
        
        return detailSubject
    }
    
}
