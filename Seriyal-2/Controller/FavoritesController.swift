//
//  FavoritesController.swift
//  Seriyal-2
//
//  Created by Zsolt Nagy on 2017. 11. 03..
//  Copyright © 2017. Zsolt Nagy. All rights reserved.
//

import UIKit
import CoreData

class FavoritesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var favoriteShows = [SeriesCore]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var singleShow = SeriesCore()
        let cell = tableView.dequeueReusableCell(withIdentifier: "seriesCell", for: indexPath) as! seriesCell
        
        singleShow = favoriteShows[indexPath.row]
        let showCoverUrl = URL(string: singleShow.imageURL!)
        
        cell.cellTitle.text = singleShow.title
        cell.cellImage.kf.setImage(with: showCoverUrl)
        cell.cellSummary.text = singleShow.summary
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        favoritesTable.reloadData()
        
        self.fetch { (complete) in
            if complete {
                print("Complete the fetch, has data")
            }
        }
    }
    
    @IBOutlet var favoritesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "seriesCell", bundle: nil)
        favoritesTable.register(nib, forCellReuseIdentifier: "seriesCell")
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
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

extension FavoritesController {
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SeriesCore")
        
        do {
            favoriteShows = try managedContext.fetch(fetchRequest) as! [SeriesCore]
            print("FETCHED THE DATA")
            completion(true)
        } catch {
            debugPrint("COULD NOT FETCH")
            completion(false)
        }
        
    }
    
}
