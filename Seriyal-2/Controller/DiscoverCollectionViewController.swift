//
//  DiscoverCollectionViewController.swift
//  Seriyal-2
//
//  Created by Zsolt Nagy on 2017. 11. 12..
//  Copyright © 2017. Zsolt Nagy. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData
import Segmentio
import UIImageColors
import HexColors

class DiscoverCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var segmentioView: Segmentio!
    @IBOutlet weak var collectionView: UICollectionView!
    var fetcher = Fetcher()
    var shows : [SeriesCore] = []
    let barDark = UIColor("#1C1C1C")
    let darkSecondary = UIColor("#202020")
    let indicatorColor = UIColor("#C6340B")
    var selectedShowCoreId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = nil
        setupCell()
        segmentedControl()
        resetColors()
        
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
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = darkSecondary!
        navigationController?.navigationBar.isTranslucent = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        segmentioView.selectedSegmentioIndex = 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        cell.awakeFromNib()
        
        let selectedIndex = segmentioView.selectedSegmentioIndex
        switch selectedIndex
        {
        case 0:
            return fillCollection(onList: "popular", filterBy: "popular", indexPath: indexPath)
        case 1:
            return fillCollection(onList: "topRated", filterBy: "top_rated", indexPath: indexPath)
        case 2:
            return fillCollection(onList: "airingToday", filterBy: "airing_today", indexPath: indexPath)
        default:
            return fillCollection(onList: "popular", filterBy: "popular", indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getSelectedShowId(indexPath: indexPath)
        performSegue(withIdentifier: "fromShowToSingle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let singleVC = segue.destination as? SingleController
        singleVC?.singleShowId = selectedShowCoreId
    }
    
    func getSelectedShowId(indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SeriesCore")
        
        do {
            shows = try managedContext.fetch(fetchRequest) as! [SeriesCore]
            let show = shows[indexPath.row]
            selectedShowCoreId = show.id!
        } catch {
            debugPrint("COULD NOT FETCH")
        }
    }
    
    func setupCell() {
        self.collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        
        let cellWidthThird = ((collectionView.bounds.width / 3) - 10)
        let cellSize = CGSize(width:cellWidthThird, height:210)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func segmentedControl() {
        var content = [SegmentioItem]()
        
        let popularItem = SegmentioItem(
            title: "Popular",
            image: nil
        )
        let topRatedItem = SegmentioItem(
            title: "Top Rated",
            image: nil
        )
        let airingTodayItem = SegmentioItem(
            title: "Airing Today",
            image: nil
        )
        content.append(popularItem)
        content.append(topRatedItem)
        content.append(airingTodayItem)
        
        let indicatorOptions = SegmentioIndicatorOptions(type: .bottom, ratio: 0.5, height: 2, color: indicatorColor!)
        let horizontalSeparator = SegmentioHorizontalSeparatorOptions(type: SegmentioHorizontalSeparatorType.bottom, height: 0.1, color: UIColor.black)
        let verticalSeparator = SegmentioVerticalSeparatorOptions(ratio: 0.7, color: UIColor.darkGray)
        
        let states = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: 12),
                titleTextColor: .lightGray
            ),
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 100)),
                titleTextColor: .white
            ),
            highlightedState: SegmentioState(
                backgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                titleFont: UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .black
            )
        )
        
        let options = SegmentioOptions(backgroundColor: darkSecondary!, maxVisibleItems: 3, scrollEnabled: false, indicatorOptions: indicatorOptions, horizontalSeparatorOptions: horizontalSeparator, verticalSeparatorOptions: verticalSeparator, imageContentMode: .center, labelTextAlignment: NSTextAlignment.center, labelTextNumberOfLines: 1, segmentStates: states, animationDuration: 0.3)
        
        segmentioView.setup(
            content: content,
            style: SegmentioStyle.onlyLabel,
            options: options
        )
        
        segmentioView.valueDidChange = { segmentio, segmentIndex in
            print("Selected item: ", segmentIndex)
            self.collectionView.reloadData()
        }
        
        segmentioView.layer.shadowColor = UIColor.black.cgColor
        segmentioView.layer.shadowOffset = CGSize(width: 0, height: 2)
        segmentioView.layer.shadowOpacity = 0.2
        segmentioView.layer.shadowRadius = 2
    }
    
    func getData(filter: String) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SeriesCore")
        
        let filter = filter
        let predicate = NSPredicate(format: "onList = %@", filter)
        fetchRequest.predicate = predicate
        
        do {
            shows = (try managedContext.fetch(SeriesCore.fetchRequest()))
            self.collectionView.reloadData()
        } catch {
            print("was error in fetching")
        }
    }
    
    func resetColors() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = barDark
    }
    
    func fillCollection(onList: String, filterBy: String, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return cell }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SeriesCore")
        
        var apiShow = Series()
        
        let predicate = NSPredicate(format: "onList = %@", onList)
        fetchRequest.predicate = predicate
        do {
            let count = try managedContext.count(for: fetchRequest)
            if (count == 0) {
                fetcher.apiRequestForList(filterBy: filterBy, completion: { (complete) in
                    if complete {
                        var discoverMostPopularList = self.fetcher.discoverMostPopular
                        apiShow = discoverMostPopularList[indexPath.row]
                        
                        let singleImageUrl = URL(string: apiShow.imageURL)
                        cell.collectionImage.kf.indicatorType = .activity
                        cell.collectionImage.kf.setImage(with: singleImageUrl)
                        cell.collectionLabel.text = apiShow.title
                    }
                })
            } else {
                shows = try managedContext.fetch(fetchRequest) as! [SeriesCore]
                let show = shows[indexPath.row]
                
                let singleImageUrl = URL(string: show.imageURL!)
                cell.collectionImage.kf.indicatorType = .activity
                cell.collectionImage.kf.setImage(with: singleImageUrl)
                cell.collectionLabel.text = show.title
                
//                ImageCache.default.retrieveImage(forKey: show.id!, options: nil) {
//                    savedImage, cacheType in
//                    if let savedImage = savedImage {
//                        print("Get image \(savedImage), cacheType: \(cacheType).")
//                    } else {
//                        print("Not exist in cache.")
//                    }
//                }
                
                //let imageUrl = singleImageUrl
                ImageDownloader.default.downloadImage(with: singleImageUrl!, options: [], progressBlock: nil) {
                    (image, error, url, data) in
    
                    image?.getColors(scaleDownSize: CGSize.init(width: 40, height: 40), completionHandler: { (colors) in
                        cell.collectionCard.backgroundColor = colors.primary
                        
                        if (cell.collectionCard.backgroundColor?.isLight)! {
                            cell.collectionLabel.textColor = UIColor.black
                        } else {
                            cell.collectionLabel.textColor = UIColor.white
                        }
                        
                    })
                }
                print("FETCHED THE DATA")
            }
        } catch {
            debugPrint("COULD NOT FETCH")
        }
        print("segmentioselected")
        return cell
    }
    
    func cacheImage(imageToCache: UIImage, keyForImage: String) {
        let image: UIImage = imageToCache
        ImageCache.default.store(image, forKey: keyForImage)
    }
    
}
