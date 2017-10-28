//
//  api.swift
//  Seriyal-2
//
//  Created by Zsolt Nagy on 2017. 10. 23..
//  Copyright © 2017. Zsolt Nagy. All rights reserved.
//

import Foundation
import Alamofire
import Kingfisher
import SwiftyJSON

class API {
    
    let api_key = "0b4398f46941f1408547bd8c1f556294"
    let baseUrl = ""
    
    var showTitle = ""
    var showImageUrl = ""
    var showEpisodeNumber = ""
    var showSeasonsNumber = ""
    var showGenre = ""
    var showRating = ""
    var showSummary = ""
    
    func getSeriesData() {
        
        let popularSeriesUrl = "https://api.themoviedb.org/3/discover/tv?api_key=\(api_key)&language=en-US&sort_by=popularity.desc&page=1&timezone=Europe%2FBudapest&include_null_first_air_dates=false"
        
        Alamofire.request(popularSeriesUrl).responseJSON { response in
            
                        if response.result.isSuccess {
            
                            print("Success! Got the data")
            
                            let seriesJSON : JSON = JSON(response.result.value!)

                            self.showTitle = seriesJSON["results"][0]["name"].stringValue
                            
            
                            //self.discoverTopRatedCollection.reloadData()
            
                            //PersistenceService.saveContext()
            
                        } else {
                            print("Error \(String(describing: response.result.error))")
                        }
            
                    }
        
    }
    
}
