//
//  SearchController.swift
//  Seriyal-2
//
//  Created by Zsolt Nagy on 2017. 11. 04..
//  Copyright © 2017. Zsolt Nagy. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON
import UIImageColors

class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var searchResultsTable: UITableView!
    
    // Show details for moving data
    var tapShowTitle = ""
    var tapShowDescription = ""
    var tapShowId = ""
    var tapShowFeaturedImageUrl = ""
    var tapsShowId = ""
    var tapShowSeasonsNumber = ""
    var tapShowEpisodesNumber = ""
    
    let textArray = ["one", "two", "three", "four", "five"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            if filteredShows.count > 10 {
               return 10
            } else {
                return filteredShows.count
            }
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "seriesCell", for: indexPath) as! seriesCell
        var singleShow = Series()
        
        if isFiltering() {
            let cell = tableView.dequeueReusableCell(withIdentifier: "seriesCell", for: indexPath) as! seriesCell
            
            singleShow = filteredShows[indexPath.row]
            
            let showCoverUrl = URL(string: singleShow.imageURL)
            
            cell.cellTitle.text = singleShow.title
            cell.cellImage.kf.setImage(with: showCoverUrl)
            cell.cellSummary.text = singleShow.description
            
            return cell
        } else {
            
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
            cell.textLabel?.text = "text"
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedShow = filteredShows[indexPath.row]
        
        tapShowFeaturedImageUrl = selectedShow.imageURL
        tapShowDescription = selectedShow.description
        tapShowTitle = selectedShow.title
        tapShowId = selectedShow.id
        
        performSegue(withIdentifier: "goToSingle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        let destinationVC = segue.destination as? SingleController
//        destinationVC?.selectedShowDescription = tapShowDescription
//        destinationVC?.selectedShowFeaturedImage = tapShowFeaturedImageUrl
//        destinationVC?.selectedShowTitle = tapShowTitle
//        destinationVC?.selectedShowId = tapShowId
       
        
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredShows = [Series]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Shows"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        
        let nib = UINib(nibName: "seriesCell", bundle: nil)
        searchResultsTable.register(nib, forCellReuseIdentifier: "seriesCell")
        
        let searchNib = UINib(nibName: "searchCell", bundle: nil)
        searchResultsTable.register(searchNib, forCellReuseIdentifier: "searchCell")
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        if isFiltering() {
            searchResultsTable.separatorStyle = .none
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func removeDuplicates(array: [Series]) -> [Series] {
        var encountered = Set<Series>()
        var result: [Series] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    
    func getSearchResults() {
        
        let api_key = "0b4398f46941f1408547bd8c1f556294"
        var searchTextTypedIn = searchController.searchBar.text!
        let searchUrl = "https://api.themoviedb.org/3/search/tv?api_key=\(api_key)&language=en-US&query=\(searchTextTypedIn)&page=1"
        let imagesBaseUrl = "https://image.tmdb.org/t/p/w300"
        
        Alamofire.request(searchUrl).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let searchJSON : JSON = JSON(response.result.value!)
                let searchResult = searchJSON["results"].arrayValue
                
                var allSearchedShows = [Series]()
                var uniqueShows = [Series]()
                
                    for singleseries in searchResult {
                        
                        let show = Series()
                        let showTitle = singleseries["name"].stringValue
                        let showCoverUrl = singleseries["poster_path"].stringValue
                        let showOverview = singleseries["overview"].stringValue
                        let showId = singleseries["id"].stringValue
                        
                        
                        show.title = showTitle
                        show.imageURL = String(describing: URL(string: imagesBaseUrl + singleseries["poster_path"].stringValue)!)
                        show.description = showOverview
                        show.id = showId
                        
                        allSearchedShows.append(show)
                    }
                
                let uniqueFilteredShows = self.removeDuplicates(array: allSearchedShows)
                self.filteredShows = uniqueFilteredShows
                
                break
            case .failure( _):
                print("Error \(String(describing: response.result.error))")
                break
            }
            
            
            
      
        }
        
        
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredShows = filteredShows.filter({( show : Series) -> Bool in
            return show.title.lowercased().contains(searchText.lowercased())
        })
        
        
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        getSearchResults()
        searchResultsTable.reloadData()
    }
}
