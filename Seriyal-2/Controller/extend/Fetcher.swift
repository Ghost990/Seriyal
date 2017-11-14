//
//  Fetcher.swift
//  Seriyal-2
//
//  Created by Zsolt Nagy on 2017. 11. 09..
//  Copyright © 2017. Zsolt Nagy. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class Fetcher {
    
    private let persistenctContainer: NSPersistentContainer
    private let api_key = "0b4398f46941f1408547bd8c1f556294"
    
    var discoverMostPopular = [Series]()
    var discoverTopRated = [Series]()
    var discoverAiringToday = [Series]()
    
    var discoverCoreMostPopular = [SeriesCore]()
    var discoverCoreTopRated = [SeriesCore]()
    var discoverCoreAiringToday = [SeriesCore]()
    
    var savedInCoreList = [SeriesCore]()
    
    var showTitle = ""
    var showDescription = ""
    var showImageUrl = ""
    var showId = ""
    
    let managedContext = appDelegate?.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SeriesCore")
    
    init() {
        let modelName = "Seriyal_2"
        self.persistenctContainer = NSPersistentContainer(name: modelName)
    }
    
    func apiRequestForList(filterBy: String, completion: @escaping (_ complete: Bool) -> ()) {
        
        let baseUrl = "https://api.themoviedb.org/3/tv"
        _ = "https://api.themoviedb.org/3/tv/250/images?api_key=\(api_key)&language=en-US"
        _ = "https://api.themoviedb.org/3/configuration?api_key=\(api_key)"
        let imagesBaseUrl = "https://image.tmdb.org/t/p/w300"
        let popularSeriesUrl = "\(baseUrl)/\(filterBy)?api_key=\(api_key)&language=en-US&page=1"
        
        Alamofire.request(popularSeriesUrl).responseJSON { response in
            
            if response.result.isSuccess {
                
                do {
                    print("Success! Got the data")
                    
                    let seriesJSON : JSON = JSON(response.result.value!)
                    _ = seriesJSON["results"].dictionaryObject
                    
                    for result in seriesJSON["results"].array! {
                        
                        _ = Series()
                        
                        self.showTitle = result["name"].stringValue
                        self.showId = result["id"].stringValue
                        self.showImageUrl = String(describing: URL(string: imagesBaseUrl + result["poster_path"].stringValue)!)
                        self.showDescription = result["overview"].stringValue
                        
                        self.fillListWithApi(filterBy: filterBy)
                        
                        if filterBy == "popular" {
                            self.saveToList(showCategory: "popular")
                        }
                        else if filterBy == "top_rated" {
                            self.saveToList(showCategory: "topRated")
                        }
                        else if filterBy == "airing_today" {
                            self.saveToList(showCategory: "airingToday")
                        }
                        
                        completion(true)
                        
                    }
                } catch {
                    debugPrint("COULD NOT load")
                    completion(false)
                }
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
        
    }
    
    private func fillListWithApi(filterBy: String) {
        let show = Series()
        show.title = showTitle
        show.id = showId
        show.imageURL = showImageUrl
        show.description = showDescription
        
        if filterBy == "popular" {
            self.discoverMostPopular.append(show)
        }
        else if filterBy == "top_rated" {
            self.discoverTopRated.append(show)
        }
        else if filterBy == "airing_today" {
            self.discoverAiringToday.append(show)
        }
    }
    
    func fetchForSingle(id: String) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SeriesCore")
        
        let filter = id
        let predicate = NSPredicate(format: "id = %@", filter)
        fetchRequest.predicate = predicate
        
        do {
            let shows = try managedContext.fetch(fetchRequest) as! [SeriesCore]
            let show = shows.first
            showTitle = (show?.title)!
            showDescription = (show?.summary)!
            showImageUrl = (show?.imageURL)!
        } catch {
            debugPrint("COULD NOT FETCH")
        }
        
    }
    
    func fetchFromCore(filter: String) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SeriesCore")
        
        let filter = filter
        let predicate = NSPredicate(format: "onList = %@", filter)
        fetchRequest.predicate = predicate
        
        do {
            savedInCoreList = try managedContext.fetch(fetchRequest) as! [SeriesCore]
            print("FETCHED THE DATA")
        } catch {
            debugPrint("COULD NOT FETCH")
        }
    }
    
    func fetchFromCoreToList(filter: String, completion: (_ complete: Bool) -> ()) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SeriesCore")
        
        let filter = filter
        let predicate = NSPredicate(format: "onList = %@", filter)
        fetchRequest.predicate = predicate
        
        do {
            savedInCoreList = try managedContext.fetch(fetchRequest) as! [SeriesCore]
            print("FETCHED THE DATA")
            completion(true)
        } catch {
            debugPrint("COULD NOT FETCH")
            completion(false)
        }
    }
    
    func saveToList(showCategory: String) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let show = SeriesCore(context: managedContext)
        let singleShow = Series()
        
        var coreList = (discoverMostPopular + discoverTopRated + discoverAiringToday)
        
        for coreShow in coreList {
            show.title = coreShow.title
            show.imageURL = coreShow.imageURL
            show.summary = coreShow.description
            show.onList = showCategory
            show.id = showId
        }
        
        
        do {
            try managedContext.save()
            print("SAVED DATA")
        } catch {
            debugPrint("ERROR IN SAVING: \(error.localizedDescription)")
        }
        
    }
    
}
