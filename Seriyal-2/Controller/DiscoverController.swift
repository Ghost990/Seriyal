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
    var showSeasonsNumber = Int()
    
    // Show details for moving data
    var tapShowTitle = ""
    var tapShowDescription = ""
    var tapShowId = ""
    var tapShowFeaturedImageUrl = ""
    var tapsShowId = ""
    var tapShowSeasonsNumber = ""
    var tapShowEpisodesNumber = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        resetColors()
        getSeries()
        
        let nib = UINib(nibName: "seriesCell", bundle: nil)
        discoverTable.register(nib, forCellReuseIdentifier: "seriesCell")
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        discoverTable.separatorStyle = .none
        
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
        
        let selectedShow = discoverMostPopular[indexPath.row]
        tapShowFeaturedImageUrl = selectedShow.imageURL
        tapShowDescription = selectedShow.description
        tapShowTitle = selectedShow.title
        tapShowId = selectedShow.id
        
        
        
        performSegue(withIdentifier: "fromShowToSingle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as? SingleController
        destinationVC?.selectedShowDescription = tapShowDescription
        destinationVC?.selectedShowFeaturedImage = tapShowFeaturedImageUrl
        destinationVC?.selectedShowTitle = tapShowTitle
        destinationVC?.selectedShowId = tapShowId
        
////        getSelectedShowInfos(showId: tapsShowId)
//        destinationVC?.selectedShowSeasons = tapShowSeasonsNumber
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        resetColors()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        
    }
    
//    func getSelectedShowInfos(showId : String) {
//
//        let api_key = "0b4398f46941f1408547bd8c1f556294"
//        let extrasBaseUrl = "https://api.themoviedb.org/3/tv"
//
//        var showExtasUrl = "\(extrasBaseUrl)/\(showId)?api_key=\(api_key)"
//
//        Alamofire.request(showExtasUrl).responseJSON { response in
//
//            if response.result.isSuccess {
//
//                print("Success! Got the data")
//
//                let seriesJSON : JSON = JSON(response.result.value!)
//
//                let show = Series()
//                show.seasonsNumber = seriesJSON["number_of_seasons"].stringValue
////                self.tapShowSeasonsNumber = seriesJSON["number_of_seasons"].stringValue
//                self.tapShowSeasonsNumber = show.seasonsNumber
//
//            } else {
//                print("Error \(String(describing: response.result.error))")
//            }
//
//
//        }
//
//    }
    
    
    // series data
    func getSeries() {
        
        let baseUrl = "https://api.themoviedb.org/3/discover/tv?api_key="
        let imagesUrl = "https://api.themoviedb.org/3/tv/250/images?api_key=\(api_key)&language=en-US"
        let configurationUrl = "https://api.themoviedb.org/3/configuration?api_key=\(api_key)"
        let imagesBaseUrl = "https://image.tmdb.org/t/p/w300"
        
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
                    
//                    for season in seasonsArray! {
//                        var seasonCount = season[].count
//                        self.showSeasonsNumber = seasonCount
//                    }
//
                    //show.imageURL = imagesBaseUrl + result["poster_path"].stringValue
                    
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
    
//    func colorSetter() {
//        
//        
//            
//            let showFeaturedImageUrl = URL(string: tapShowFeaturedImageUrl)
//        
//            let showVC = SingleController()
//            
//            ImageDownloader.default.downloadImage(with: showFeaturedImageUrl!, options: [], progressBlock: nil) {
//                (image, error, url, data) in
//                
//                image?.getColors(scaleDownSize: CGSize.init(width: 40, height: 40), completionHandler: { (colors) in
//                    
//                    
//                    
//                    showVC.nextEpisodeButton.backgroundColor = colors.primary
//                    showVC.singleShowEpisodes.textColor = colors.detail
//                    showVC.singleShowSeasons.textColor = colors.detail
//                    showVC.singleShowRuntime.textColor = colors.detail
//                    showVC.singleViewNextEpisodeLabel.textColor = colors.primary
//                    showVC.episodesTitleLabel.textColor = colors.detail
//                    showVC.genresTitleLabel.textColor = colors.detail
//                    showVC.runtimeTitleLabel.textColor = colors.detail
//                    showVC.genresInfo.textColor = colors.detail
//                    showVC.runtimeInfo.textColor = colors.detail
//                    //                self.nextEpisodeTitle.textColor = colors.primary
//                    //                self.nextEpisodeOverview.textColor = colors.primary
//                    //                self.nextEpisodeOverviewLabel.textColor = colors.primary
//                    showVC.seriesInfoLabel.textColor = colors.primary
//                    //                self.episodeSeparator.backgroundColor = colors.primary
//                    
//                    showVC.singleShowBackground.backgroundColor = colors.background
//                    showVC.view.backgroundColor = colors.background
//                    //self.navigationController?.navigationBar.barTintColor = UIColor.clear
//                    showVC.gradientView.setGradientBackground(colorOne: colors.background.withAlphaComponent(0.01), colorTwo: colors.background.withAlphaComponent(0.5), colorThree: colors.background.withAlphaComponent(1.0))
//                    let attributes = [
//                        NSAttributedStringKey.foregroundColor : colors.primary
//                    ]
//                    showVC.navigationController?.navigationBar.largeTitleTextAttributes = attributes
//                    showVC.navigationController?.navigationBar.tintColor = colors.primary
//                    showVC.singleViewDescription.textColor = colors.primary
//                    
//                    //                self.navigationController?.navigationBar.isTranslucent = true
//                    //                self.navigationController?.view.backgroundColor = UIColor.clear
//                    //                self.navigationController?.navigationBar.barTintColor = UIColor.clear
//                    //                UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//                    //
//                    //                // Sets shadow (line below the bar) to a blank image
//                    //                UINavigationBar.appearance().shadowImage = UIImage()
//                    //                UINavigationBar.appearance().isTranslucent = true
//                    
//                    //                self.navigationController?.navigationBar.barTintColor = colors.background
//                    //self.navigationController?.navigationBar.tintColor = colors.primary
//                    
//                    //                destinationVC?.singleShowTitle.textColor = colors.primary
//                    //                destinationVC?.singleViewDescription.textColor = colors.primary
//                    //                destinationVC?.view.backgroundColor = colors.background
//                    //                destinationVC?.nextEpisodeButton.backgroundColor = colors.primary
//                    
//                    //                destinationVC?.navigationController?.navigationBar.barTintColor = colors.background
//                    //                destinationVC?.navigationController?.navigationBar.tintColor = colors.primary
//                    
//                    let color = colors.primary
//                    
//                    if (color?.isLight)! {
//                        showVC.nextEpisodeButton.setTitleColor(UIColor.black, for: .normal)
//                    } else {
//                        showVC.nextEpisodeButton.setTitleColor(UIColor.white, for: .normal)
//                    }
//                    
//                    let bgColor = colors.background
//                    let defaultDarkColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
//                    
//                    if (bgColor?.isLight)! {
//                        
//                        showVC.blurEffect(style: UIBlurEffect(style: .light))
//                    } else {
//                        
//                        showVC.blurEffect(style: UIBlurEffect(style: .dark))
//                    }
//                    
//                    
//                    
//                })
//                
//            }
//            
////            showVC.singleShowCover.layer.shadowColor = UIColor.black.cgColor
////            showVC.singleShowCover.layer.shadowOffset = CGSize(width: 0, height: 2)
////            showVC.singleShowCover.layer.shadowOpacity = 0.5
////            showVC.singleShowCover.layer.shadowRadius = 6
//        
//        
//    }
    
    func resetColors() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

