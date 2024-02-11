//
//  DetailViewModel.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import RxSwift
final class DetailViewModel: BaseViewModel {
    // Dispose bag to manage disposables
    private let disposeBag = DisposeBag()

    // Subject to emit the detail information along with the movie poster images
    private var detailSubject: PublishSubject<(DetailModel, MoviePosterModel)> = PublishSubject()

    // Movie poster images source
    private var imagesSource: MoviePosterModel?

    // Detail information source
    var detailSource: DetailModel?

    // Subject to indicate whether the operation is completed or not
    private var isDone: PublishSubject<Bool> = PublishSubject()

    // Arrays to store cast, header data, and similar movies data
    private var cast = [Cast]()
    private var headerDataSource = [DetailHeaderModel]()
    private var similarDataSource = [SimilarResult]()

    // Initialization
    override init() {
        super.init()
    }

    // Setup similar movies data source
    private func setupSimilarDataSource() {
        // Check if there are similar movies available and extract the first 10, sorted by vote average
        if let similar = detailSource?.similar, let results = similar.results?.prefix(10).sorted(by: { $0.voteAverage ?? 0 > $1.voteAverage ?? 0 }) {
            // Assign the extracted similar movies to the similarDataSource array
            similarDataSource = results
        }
    }

    // Setup cast data source
    private func setupCastindDataSource() {
        // Check if cast members are available
        if let cast = detailSource?.credits?.cast {
            // Filter cast members based on their known department being "Acting", take the first 8, and sort them by popularity
            self.cast = cast.filter { $0.knownForDepartment?.rawValue ?? "" == "Acting" }.prefix(8).sorted(by: { $0.popularity ?? 0 > $1.popularity ?? 0 })
        }
    }

    // Setup header data source
    private func setupHeaderDataSource() {
        // Check if there are available images and videos
        if let imagesSource, let backdrops = imagesSource.backdrops {
            // Filter available backdrops with aspect ratio greater than 15/9, take the first 4, and sort them by vote average
            let avaibleImages = backdrops.filter { $0.aspectRatio ?? 0 > 15 / 9 }.sorted(by: { $0.voteAverage ?? 0 > $1.voteAverage ?? 0 }).prefix(4)
            // For each available backdrop, create a DetailHeaderModel instance with type .image and append it to the headerDataSource array
            avaibleImages.forEach { backdrops in
                headerDataSource.append(DetailHeaderModel(sourcePath: backdrops.filePath, type: .image))
            }
        }

        // Check if there are official teaser videos available
        if let officailVideo = detailSource?.videos {
            // Find the first teaser video that is official and from YouTube, if any
            let video = officailVideo.results?.filter { $0.official == true && $0.type == "Teaser" && $0.site?.rawValue ?? "" == Site.youTube.rawValue }.first
            // If a teaser video is found, create a DetailHeaderModel instance with type .video and append it to the headerDataSource array
            if let videoKey = video?.key {
                headerDataSource.append(DetailHeaderModel(sourcePath: videoKey, type: .video))
            }
        }
        // Emit true through the isDone subject to indicate that the setup is complete
        isDone.onNext(true)
    }

    // Function to load detail information of a movie
    func loadDetail(id: Int) -> PublishSubject<Bool> {
        // Indicating loading
        isLoading.onNext(true)

        // Making network requests to get detail and images data
        getDetail(id: id)?.subscribe(onNext: { datail, images in
            self.imagesSource = images
            self.detailSource = datail
            // Setting up similar movies, cast, and header data sources
            self.setupSimilarDataSource()
            self.setupCastindDataSource()
            self.setupHeaderDataSource()
        }, onError: { error in
            // Handling error
            self.isDone.onError(error)
        }).disposed(by: disposeBag)
        return isDone
    }

    // Function to get header data source
    func getHeaderDataSource() -> [DetailHeaderModel] {
        return headerDataSource
    }

    // Function to get cast data source
    func getCastDataSource() -> [Cast] {
        return cast
    }

    // Function to get similar movies data source
    func getSimilarDataSource() -> [SimilarResult] {
        return similarDataSource
    }

    // Function to get detail from API
    private func getDetail(id: Int) -> PublishSubject<(DetailModel, MoviePosterModel)>? {
        // Making network requests to get detail and images data
        let movieDetail = detailProvider.rx.request(.getDetail(id: id)).map(DetailModel.self).asObservable()
        let movieImages = detailProvider.rx.request(.getImages(id: id)).map(MoviePosterModel.self).asObservable()

        // Observing both requests and emitting the result
        Observable.zip(movieDetail, movieImages)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] elements in
                switch elements {
                case let .next(response):
                    self?.isLoading.onNext(false)
                    self?.detailSubject.onNext(response)
                case let .error(error):
                    self?.isLoading.onNext(false)
                    self?.detailSubject.onError(error)
                default:
                    self?.isLoading.onNext(false)
                }
            }.disposed(by: disposeBag)

        return detailSubject
    }
}
