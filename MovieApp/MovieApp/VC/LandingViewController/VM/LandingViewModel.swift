//
//  LandingViewModel.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import Foundation
final class LandingViewModel {
    private var dataSource : [LandingModel] = []
    
    init(){  setupDataSource()  }
    
    private func setupDataSource() {
        dataSource.append(LandingModel(imageName: "landing1", title: "Explore", description: "Discover newly released and most acclaimed movies."))
        dataSource.append(LandingModel(imageName: "landing2", title: "Add to List", description: "Add movies you've previously watched to your list."))
        dataSource.append(LandingModel(imageName: "landing3", title: "Details", description: "Learn about the details of movies and TV shows, including their cast and directors."))
    }
    
    func getCellForItem(indexPath : Int) -> LandingModel{
       return dataSource[indexPath]
    }
    
    func getNumberOfInSection() -> Int{
        return dataSource.count
    }
}
