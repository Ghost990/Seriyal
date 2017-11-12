//
//  discoverCollectionController.swift
//  Seriyal-2
//
//  Created by Zsolt Nagy on 2017. 11. 12..
//  Copyright © 2017. Zsolt Nagy. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

var savedInCoreList = [SeriesCore]()



var filterList = "popular"

var shows : [SeriesCore] = []

class discoverCollectionController: UITableViewController {
    
    var fetcher = Fetcher()
    
    let model = generateRandomData()
    var storedOffsets = [Int: CGFloat]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let screenHeight = UIScreen.main.bounds.height
        
        return screenHeight
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        

        
    }
    
    func getData(filter: String) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SeriesCore")
        
        let filter = filter
        let predicate = NSPredicate(format: "onList = %@", filter)
        fetchRequest.predicate = predicate
        
        do {
            shows = (try managedContext.fetch(SeriesCore.fetchRequest()))
            tableView.reloadData()
        } catch {
            print("was error in fetching")
        }
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

extension discoverCollectionController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return cell }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SeriesCore")
        
        var apiShow = Series()
        
        let predicate = NSPredicate(format: "onList = %@", "popular")
        fetchRequest.predicate = predicate
        
        fetcher.apiRequestForList(filterBy: "popular", completion: { (complete) in
            if complete {
                var discoverMostPopularList = self.fetcher.discoverMostPopular
                apiShow = discoverMostPopularList[indexPath.row]
                
                let singleImageUrl = URL(string: apiShow.imageURL)
                cell.showCover.kf.setImage(with: singleImageUrl)
                cell.showTitle.text = apiShow.title
            }
        })
        
        //cell.backgroundColor = model[collectionView.tag][indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}
