//
//  ViewController.swift
//  Seriyal-2
//
//  Created by Zsolt Nagy on 2017. 10. 23..
//  Copyright © 2017. Zsolt Nagy. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON
import UIImageColors

class DiscoverController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let api_key = "0b4398f46941f1408547bd8c1f556294"
    @IBOutlet weak var discoverTable: UITableView!
    
    var showTitle = ""
    var discoverMostPopular = [Series]()
    var testArr = ["one", "two", "three"]
    var showIdArray = [String]()
    var showImagesUrlArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSeries()
        
        
        let nib = UINib(nibName: "seriesCell", bundle: nil)
        discoverTable.register(nib, forCellReuseIdentifier: "seriesCell")
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //discoverTable.separatorStyle = .none
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoverMostPopular.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "seriesCell", for: indexPath) as! seriesCell
        
        let singleShow = discoverMostPopular[indexPath.row]
        let showCoverUrl = URL(string: singleShow.imageURL)
        
        cell.cellTitle.text = singleShow.title
        cell.cellImage.kf.setImage(with: showCoverUrl)
        cell.cellSummary.text = singleShow.description
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    // series data
    func getSeries() {
        
        let baseUrl = "https://api.themoviedb.org/3/discover/tv?api_key="
        let imagesUrl = "https://api.themoviedb.org/3/tv/250/images?api_key=\(api_key)&language=en-US"
        let configurationUrl = "https://api.themoviedb.org/3/configuration?api_key=\(api_key)"
        let imagesBaseUrl = "https://image.tmdb.org/t/p/w185"
        
        let popularSeriesUrl = "\(baseUrl)\(api_key)&language=en-US&sort_by=popularity.desc&page=1&timezone=Europe%2FBudapest&include_null_first_air_dates=false"
        
        Alamofire.request(popularSeriesUrl).responseJSON { response in
            
            if response.result.isSuccess {
                
                print("Success! Got the data")
                
                let seriesJSON : JSON = JSON(response.result.value!)
                let seriesResult = seriesJSON["results"].arrayValue
                

                for result in seriesJSON["results"].array! {
                    let show = Series()
                    show.title = result["name"].stringValue
                    show.id = result["id"].stringValue
                    show.imageURL = String(describing: URL(string: imagesBaseUrl + result["poster_path"].stringValue)!)
                    show.description = result["overview"].stringValue
                    
                    //show.imageURL = imagesBaseUrl + result["poster_path"].stringValue
                    print(show.imageURL)
                    
                    self.showIdArray.append(show.id)
                    self.showImagesUrlArray.append(show.imageURL)
                    
                    
                    self.discoverMostPopular.append(show)
                    
                }
                
                
                
//                for subJson in seriesResult {
//
//                    let singleShowTitle = subJson["name"].stringValue
//                    print(singleShowTitle)
//                    self.showTitle = singleShowTitle
//
//                }
                
                
                
                //self.showTitle = seriesJSON["results"][0]["name"].stringValue
                
                self.discoverTable.reloadData()
                
                //self.discoverTopRatedCollection.reloadData()
                
                //PersistenceService.saveContext()
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
            
            
        }
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

