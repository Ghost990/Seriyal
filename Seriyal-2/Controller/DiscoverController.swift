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
import CoreData

class DiscoverController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let api_key = "0b4398f46941f1408547bd8c1f556294"
    @IBOutlet weak var discoverTable: UITableView!
    
    @IBOutlet weak var categoryControl: UISegmentedControl!
    
    
    var showTitle = ""
    var discoverMostPopular = [Series]()
    var discoverTopRated = [Series]()
    var discoverAiringToday = [Series]()
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
    var allShowsId = ""
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredShows = [Series]()
    
    var savedInCoreList = [SeriesCore]()
    
    var fetcher = Fetcher()
    
    var filterList = "popular"
    
    var shows : [SeriesCore] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = nil
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SeriesCore")
        
        let predicate = NSPredicate(format: "onList = %@", "popular")
        fetchRequest.predicate = predicate
        do {
            let count = try managedContext.count(for: fetchRequest)
            if(count == 0){
                fetcher.apiRequestForList(filterBy: "popular", completion: { (complete) in
                    if complete {
                        print("got from onload api")
                    }
                })
            } else {
                getData(filter: "popular")
            }
        } catch {
            debugPrint("COULD NOT FETCH")
        }
        
        resetColors()
        
        let nib = UINib(nibName: "seriesCell", bundle: nil)
        discoverTable.register(nib, forCellReuseIdentifier: "seriesCell")
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        discoverTable.separatorStyle = .none
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "seriesCell", for: indexPath) as! seriesCell
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return cell }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SeriesCore")
        
        var apiShow = Series()
        
        let selectedIndex = self.categoryControl.selectedSegmentIndex
        switch selectedIndex
        {
        case 0:
            let predicate = NSPredicate(format: "onList = %@", "popular")
            fetchRequest.predicate = predicate
            do {
                let count = try managedContext.count(for: fetchRequest)
                if(count == 0){
                    fetcher.apiRequestForList(filterBy: "popular", completion: { (complete) in
                        if complete {
                            var discoverMostPopularList = self.fetcher.discoverMostPopular
                            apiShow = discoverMostPopularList[indexPath.row]
                            cell.cellTitle.text = "fromapi \(apiShow.title)"
                        }
                    })
                } else {
                    shows = try managedContext.fetch(fetchRequest) as! [SeriesCore]
                    let show = shows[indexPath.row]
                    cell.cellTitle.text = show.title
                    print("FETCHED THE DATA")
                }
            } catch {
                debugPrint("COULD NOT FETCH")
            }
            return cell
        case 1:
            let predicate = NSPredicate(format: "onList = %@", "topRated")
            fetchRequest.predicate = predicate
            do {
                let count = try managedContext.count(for: fetchRequest)
                if(count == 0){
                    fetcher.apiRequestForList(filterBy: "top_rated", completion: { (complete) in
                        if complete {
                            var discoverTopRatedList = self.fetcher.discoverTopRated
                            apiShow = discoverTopRatedList[indexPath.row]
                            cell.cellTitle.text = "fromapi \(apiShow.title)"
                        }
                    })
                } else {
                    shows = try managedContext.fetch(fetchRequest) as! [SeriesCore]
                    let show = shows[indexPath.row]
                    cell.cellTitle.text = show.title
                    print("FETCHED THE DATA")
                }
            } catch {
                debugPrint("COULD NOT FETCH")
            }
            return cell
        case 2:
            let predicate = NSPredicate(format: "onList = %@", "airingToday")
            fetchRequest.predicate = predicate
            do {
                let count = try managedContext.count(for: fetchRequest)
                if(count == 0){
                    fetcher.apiRequestForList(filterBy: "airing_today", completion: { (complete) in
                        if complete {
                            var discoverAiringTodayList = self.fetcher.discoverAiringToday
                            apiShow = discoverAiringTodayList[indexPath.row]
                            cell.cellTitle.text = "fromapi \(apiShow.title)"
                        }
                    })
                } else {
                    shows = try managedContext.fetch(fetchRequest) as! [SeriesCore]
                    let show = shows[indexPath.row]
                    cell.cellTitle.text = show.title
                    print("FETCHED THE DATA")
                }
            } catch {
                debugPrint("COULD NOT FETCH")
            }
            return cell
        default:
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var discoverMostPopularList = fetcher.discoverMostPopular
        var discoverTopRatedList = fetcher.discoverTopRated
        var discoverAiringTodayList = fetcher.discoverAiringToday
        
        
        
        performSegue(withIdentifier: "fromShowToSingle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
//        let destinationVC = segue.destination as? SingleController
//        destinationVC?.selectedShowDescription = tapShowDescription
//        destinationVC?.selectedShowFeaturedImage = tapShowFeaturedImageUrl
//        destinationVC?.selectedShowTitle = tapShowTitle
//        destinationVC?.selectedShowId = tapShowId
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getData(filter: "airingToday")
        
        resetColors()
        navigationItem.title = categoryControl.titleForSegment(at: 0)
        
        self.discoverTable.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        
    }
    
    func getData(filter: String) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SeriesCore")
        
        let filter = filter
        let predicate = NSPredicate(format: "onList = %@", filter)
        fetchRequest.predicate = predicate
        
        do {
            shows = (try managedContext.fetch(SeriesCore.fetchRequest()))
            self.discoverTable.reloadData()
        } catch {
            print("was error in fetching")
        }
    }
    
    
    // series data
    func getSeries(filterBy: String) {
        
        let baseUrl = "https://api.themoviedb.org/3/tv"
        let imagesUrl = "https://api.themoviedb.org/3/tv/250/images?api_key=\(api_key)&language=en-US"
        let configurationUrl = "https://api.themoviedb.org/3/configuration?api_key=\(api_key)"
        let imagesBaseUrl = "https://image.tmdb.org/t/p/w300"
        
        
        let popularSeriesUrl = "\(baseUrl)/\(filterBy)?api_key=\(api_key)&language=en-US&page=1"
        
        
        Alamofire.request(popularSeriesUrl).responseJSON { response in
            
            if response.result.isSuccess {
                
                print("Success! Got the data")
                
                let seriesJSON : JSON = JSON(response.result.value!)
                let seriesResult = seriesJSON["results"].dictionaryObject
                
                let stackResult = JSON(response.result.value!).dictionaryObject
                
                //let seriesCore = seriesResult as! [String: Any]

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
                    
                    
                    if filterBy == "popular" {
                        self.discoverMostPopular.append(show)
                    }
                    else if filterBy == "top_rated" {
                        self.discoverTopRated.append(show)
                    }
                    else if filterBy == "airing_today" {
                        self.discoverAiringToday.append(show)
                    }
                    
//                    self.save { (complete) in
//                        if complete {
//                            print("COMPLETE")
//                        }
//                    }
                    
//                    dataStack.sync([seriesCore], inEntityNamed: "SeriesCore") { error in
//                        // New objects have been inserted
//                        // Existing objects have been updated
//                        // And not found objects have been deleted
//                    }
                    
//                    var singleShow = SeriesCore()
//                    var singleShowId = singleShow.id
//                    
//                    if show.id != singleShowId {
//                        self.save { (complete) in
//                            if complete {
//                                print("COMPLETE")
//                            }
//                        }
//                    } else {
//                        print("already on the list")
//                        return
//                    }
                    
                    
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
    
    
    // MARK: - Private instance methods
    
//    func searchBarIsEmpty() -> Bool {
//        // Returns true if the text is empty or nil
//        return searchController.searchBar.text?.isEmpty ?? true
//    }
//
//    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
//        filteredShows = discoverMostPopular.filter({( show : Series) -> Bool in
//            return show.title.lowercased().contains(searchText.lowercased())
//        })
//
//        discoverTable.reloadData()
//    }
//
//    func isFiltering() -> Bool {
//        return searchController.isActive && !searchBarIsEmpty()
//    }
    
    @IBAction func categoryFilterTapped(_ sender: UISegmentedControl) {
        
        self.discoverTable.reloadData()
        
    }
    
    func save(completion: (_ finished: Bool) -> ()) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let show = SeriesCore(context: managedContext)
        let singleShow = Series()
        
        var coreList = (discoverMostPopular + discoverTopRated + discoverAiringToday)
        
        for coreShow in coreList {
            
            show.title = coreShow.title
            show.imageURL = coreShow.imageURL
            show.summary = coreShow.description
            
        }
        do {
            try managedContext.save()
            print("SAVED DATA")
            completion(true)
        } catch {
            debugPrint("ERROR IN SAVING: \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension DiscoverController {
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SeriesCore")
        
        do {
            savedInCoreList = try managedContext.fetch(fetchRequest) as! [SeriesCore]
            print("FETCHED THE DATA")
            completion(true)
        } catch {
            debugPrint("COULD NOT FETCH")
            completion(false)
        }
        
    }
    
}

//extension DiscoverController: UISearchResultsUpdating {
//    // MARK: - UISearchResultsUpdating Delegate
//    func updateSearchResults(for searchController: UISearchController) {
//        filterContentForSearchText(searchController.searchBar.text!)
//    }
//}

