//
//  BaseViewModel.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import RxSwift
class BaseViewModel {
    var isLoading: PublishSubject<Bool> = PublishSubject()

    init() {}
}
extension BaseViewModel{
    func getLocalJson(resource: String) -> Genres? {
        if let url = Bundle.main.url(forResource: resource, withExtension: "json") {
              do {
                  let data = try Data(contentsOf: url)
                  let decoder = JSONDecoder()
                  let jsonData = try decoder.decode(Genres.self, from: data)
                  return jsonData
              } catch {
                 return nil
              }
          }
          return nil
    }
    
    func getGenreTitle(id : Int) -> String{
        return GenreTitle(rawValue: id)?.name ?? ""
    }
    
    func getGenresDataSource () -> [GenreTitle]{
        var genres = [GenreTitle]()
        GenreTitle.allCases.forEach { title in
            genres.append(title)
        }
        return genres
    }
    
}

enum GenreTitle: Int, CaseIterable, Codable {
    case all = 0
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case romance = 10749
    case scienceFiction = 878
    case thriller = 53
    case war = 10752
   
    
    var id: Int {
        switch self {
        case .all: return 0
        case .action: return 28
        case .adventure: return 12
        case .animation: return 16
        case .comedy: return 35
        case .crime: return 80
        case .drama: return 18
        case .family: return 10751
        case .fantasy: return 14
        case .history: return 36
        case .romance: return 10749
        case .scienceFiction: return 878
        case .thriller: return 53
        case .war: return 10752
        }
    }

    
    var name: String {
        switch self {
        case .all : return "All"
        case .action: return "Action"
        case .adventure: return "Adventure"
        case .animation: return "Animation"
        case .comedy: return "Comedy"
        case .crime: return "Crime"
        case .drama: return "Drama"
        case .family: return "Family"
        case .fantasy: return "Fantasy"
        case .history: return "History"
        case .romance: return "Romance"
        case .scienceFiction: return "Science Fiction"
        case .thriller: return "Thriller"
        case .war: return "War"
        }
    }
}
