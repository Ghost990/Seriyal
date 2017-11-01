//
//  SingleController.swift
//  Seriyal-2
//
//  Created by Zsolt Nagy on 2017. 10. 28..
//  Copyright © 2017. Zsolt Nagy. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON
import UIImageColors
import SwiftDate
import EventKit
import Foundation

class SingleController: UIViewController {
    
    var selectedShowId = ""
    
    @IBOutlet weak var singleShowTitle: UILabel!
    @IBOutlet weak var singleViewImage: UIImageView!
    @IBOutlet weak var singleViewDescription: UILabel!
    @IBOutlet weak var nextEpisodeButton: UIButton!
    @IBOutlet weak var singleShowRuntime: UILabel!
    @IBOutlet weak var singleShowSeasons: UILabel!
    @IBOutlet weak var singleShowEpisodes: UILabel!
    @IBOutlet weak var singleShowBackground: UIView!
    @IBOutlet weak var singleViewNextEpisodeLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    var selectedShowNextEpisodeDate = ""
    var selectedShowTitle = ""
    var selectedShowDescription = ""
    var selectedShowFeaturedImage = ""
    var selectedShowEpisodeButton = ""
    var selectedShowRating = ""
    var selectedShowSeasons = ""
    var selectedShowEpisodes = ""
    var selectedShowSeasonImageUrl = ""
    
    var selectedShowSeasonsArray = [String]()
    var selectedShowLatestEpisodeUrl = ""
    
    var selectedShowNoNewEpisodes = ""
    
    var latestAirDates = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getExtraInfo()
        
        fillWithData()
        colorize()
        
        //self.navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.barTintColor = singleShowBackground.backgroundColor
        navigationController?.navigationBar.tintColor = singleShowTitle.textColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //fillWithData()
        getExtraInfo()
        getLatestEpisodeInfo()
        blurImage()
        
        guard let nextEpisodeAirDate = try latestAirDates.first else {
            //selectedShowNoNewEpisodes = "Already available"
            nextEpisodeButton.setTitle("Season \(self.selectedShowSeasons) available", for: .normal)
            nextEpisodeButton.tag = 1
            return
        }
        
        selectedShowNextEpisodeDate = nextEpisodeAirDate
        
        calclulateDate()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//
//
//            if self.nextEpisodeButton.titleLabel?.text == "Already available" {
//                self.nextEpisodeButton.setTitle("Season \(self.selectedShowSeasons) available", for: .normal)
//            }
//        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calclulateDate() {
        
        let now = DateInRegion()
        // Parse a string which a custom format
        let dateUntilShow = try! DateInRegion(string: "\(selectedShowNextEpisodeDate)", format: .custom("yyyy, MM, dd"), fromRegion: Region.Local())
        let dateUntilShowLong = try! dateUntilShow?.timeComponentsSinceNow(options: ComponentsFormatterOptions(allowedUnits: [.weekOfMonth,.day], style: .full, zero: .dropAll))
        
        var dateDifferenceUntilShow = ((dateUntilShow! + 1.day) - now).in(.day)
        
        if dateDifferenceUntilShow! < 2 {
            nextEpisodeButton.setTitle("Tomorrow", for: .normal)
        }
        else if (dateDifferenceUntilShow! == 0) && (dateDifferenceUntilShow! < 7) {
            nextEpisodeButton.setTitle("Today", for: .normal)
        }
        else if (dateDifferenceUntilShow! > 0) && (dateDifferenceUntilShow! < 7) {
            nextEpisodeButton.setTitle("in \(dateDifferenceUntilShow!) days", for: .normal)
        }
        else {
            nextEpisodeButton.setTitle("\(dateUntilShowLong!)", for: .normal)
        }
        
    }
    
    func fillWithData() {
        singleViewDescription.text = selectedShowDescription
        singleShowTitle.text = selectedShowTitle
        //singleShowSeasons.text = selectedShowSeasons
//        nextEpisodeButton.setTitle(selectedShowNextEpisodeDate, for: .normal)
        
        let singleImageUrl = URL(string: selectedShowFeaturedImage)
        singleViewImage.kf.setImage(with: singleImageUrl)
        
        self.navigationItem.title = selectedShowTitle
        
    }
    
    func colorize() {
        
        let showFeaturedImageUrl = URL(string: selectedShowFeaturedImage)
        
        
        ImageDownloader.default.downloadImage(with: showFeaturedImageUrl!, options: [], progressBlock: nil) {
            (image, error, url, data) in
            
            image?.getColors(scaleDownSize: CGSize.init(width: 40, height: 40), completionHandler: { (colors) in

                self.singleShowTitle.textColor = colors.primary
                self.singleViewDescription.textColor = colors.primary
                self.nextEpisodeButton.backgroundColor = colors.primary
                self.singleShowEpisodes.textColor = colors.detail
                self.singleShowSeasons.textColor = colors.detail
                self.singleShowRuntime.textColor = colors.detail
                self.singleViewNextEpisodeLabel.textColor = colors.primary
                
                self.singleShowBackground.backgroundColor = colors.background
                
                
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: colors.primary]
                
                let attributes = [
                    NSAttributedStringKey.foregroundColor : colors.primary
                ]
                
                self.navigationController?.navigationBar.largeTitleTextAttributes = attributes
                
                self.navigationController?.navigationBar.barTintColor = colors.background
                self.navigationController?.navigationBar.tintColor = colors.primary
                
//                destinationVC?.singleShowTitle.textColor = colors.primary
//                destinationVC?.singleViewDescription.textColor = colors.primary
//                destinationVC?.view.backgroundColor = colors.background
//                destinationVC?.nextEpisodeButton.backgroundColor = colors.primary
                
                //                destinationVC?.navigationController?.navigationBar.barTintColor = colors.background
                //                destinationVC?.navigationController?.navigationBar.tintColor = colors.primary
                
                let color = colors.primary
                
                if (color?.isLight)! {
                    self.nextEpisodeButton.setTitleColor(UIColor.black, for: .normal)
                } else {
                    self.nextEpisodeButton.setTitleColor(UIColor.white, for: .normal)
                }
            })
            
        }
        
    }
    
    func getExtraInfo() {

        let api_key = "0b4398f46941f1408547bd8c1f556294"
        let extrasBaseUrl = "https://api.themoviedb.org/3/tv"
        
        var latestSeasonNumberArray = [String]()
        var latestSeasonNumber = latestSeasonNumberArray.last
        
        

        var showExtasUrl = "\(extrasBaseUrl)/\(selectedShowId)?api_key=\(api_key)"
        

        Alamofire.request(showExtasUrl).responseJSON { response in

            if response.result.isSuccess {

                print("Success! Got the data")

                let seriesJSON : JSON = JSON(response.result.value!)
                
                let seasonNumber = seriesJSON["number_of_seasons"].stringValue
                let episodeNumber = seriesJSON["number_of_episodes"].stringValue
                let runtime = seriesJSON["episode_run_time"].stringValue
                let title = seriesJSON["name"].stringValue
                let nextEpisodeDate = seriesJSON["last_air_date"].stringValue
                let seasonsArray = seriesJSON["seasons"].arrayValue
                
                for season in seasonsArray {
                    let seasonNumber = season["season_number"].stringValue
                    latestSeasonNumberArray.append(seasonNumber)
                }
                
                //let latestEpisode =
                
                print(self.selectedShowId)
                
                self.singleShowSeasons.text = "\(seasonNumber) Seasons"
                self.singleShowEpisodes.text = "\(episodeNumber) Episodes"
                self.singleShowRuntime.text = "Runtime: \(runtime)"
                self.selectedShowSeasons = seasonNumber
                
                var latestSeason = latestSeasonNumberArray.last
                
                
                let latestEpisodeUrl = "\(extrasBaseUrl)/\(self.selectedShowId)/season/\(latestSeason!)?api_key=\(api_key)"
                
                let now = DateInRegion().absoluteDate
                // Parse a string which a custom format
                
                
                Alamofire.request(latestEpisodeUrl).responseJSON { response in
                    
                    if response.result.isSuccess {
                        
                        
                        let episodeJSON : JSON = JSON(response.result.value!)
                        
                        let episodesArray = episodeJSON["episodes"].arrayValue
                        
                        for episode in episodesArray {
                            let episodeAirDate = episode["air_date"].stringValue
                            
                            let showSingleAirDate = episodeAirDate
                            self.latestAirDates.append(showSingleAirDate)
                            
                            let leave_dates = self.latestAirDates
                            let today = Date()
                            let greaterThanToday = leave_dates.filter { (date) -> Bool in
                                return CustomDateFormatter.campare(date, with: today)
                            }
                            self.latestAirDates = greaterThanToday
                        }
                        
                        
                    } else {
                        print("Error \(String(describing: response.result.error))")
                    }
                    
                    
                }
                
                
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
        
        //var latestSeasonNumber = latestSeasonNumberArray.last
        
        
        
        
        
    }
    
    func getLatestEpisodeInfo() {
        
        let api_key = "0b4398f46941f1408547bd8c1f556294"
        let extrasBaseUrl = "https://api.themoviedb.org/3/tv"
        
        
        
    }
    
    func addShowToCalendar() {
        
        let eventStore : EKEventStore = EKEventStore()
        // Access permission
        eventStore.requestAccess(to: EKEntityType.event) { (granted,error) in
            
            if (granted) &&  (error == nil) {
                print("permission is granted")
                
//                let now = DateInRegion()
//                // Parse a string which a custom format
//                let showAirDate = try! DateInRegion(string: "\(self.selectedShowNextEpisodeDate)", format: .custom("yyyy, MM, dd"), fromRegion: Region.Local())
                
                
                //let dateDifferenceUntilShow = (dateUntilShow! - now).in(.day)
                let showAirDate = try! DateInRegion(string: "\(self.selectedShowNextEpisodeDate)", format: .custom("yyyy, MM, dd"), fromRegion: Region.Local())
                let showAirDateToCalendar = showAirDate?.absoluteDate
                
                let showEndDate = showAirDate! + 1.hour
                let showEndDateToCalendar = showEndDate.absoluteDate
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.selectedShowTitle
                event.startDate = showAirDateToCalendar
                event.endDate = showEndDateToCalendar
                event.notes = "This note is set up because you wanted to watch the latest \(self.selectedShowTitle) episode."
                event.calendar = eventStore.defaultCalendarForNewEvents
                event.addAlarm(EKAlarm.init(relativeOffset: 60.0))
                
                print(event.startDate)
                
                //                let alarmDate:NSDate = NSDate()
                //                print("Alarm Date: \(alarmDate)")
                //                event.addAlarm(EKAlarm.init(absoluteDate: alarmDate))
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let specError as NSError {
                    print("A specific error occurred: \(specError)")
                } catch {
                    print("An error occurred")
                }
                print("Event saved")
                
            } else {
                print("need permission to create a event")
            }
        }
        
    }
    
    @IBAction func episodeButtonTapped(_ sender: UIButton) {
        
        if nextEpisodeButton.tag == 0 {
            
            let alertController = UIAlertController(title: selectedShowTitle, message: "What would you like to do?", preferredStyle: .actionSheet)
            
            let sendButton = UIAlertAction(title: "Add to calendar", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                self.addShowToCalendar()
            })
            
            
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                print("Cancel button tapped")
            })
            
            
            alertController.addAction(sendButton)
            
            alertController.addAction(cancelButton)
            
            self.navigationController!.present(alertController, animated: true, completion: nil)
            
        } else {
            print("tag is 1")
        }
        
        
        
        
    }
    
    func blurImage() {
        
        let bgColor = singleShowBackground.backgroundColor!
        let colorAlpha = UIColor(red: 59.0/255, green: 9.0/255, blue: 68.0/255, alpha: 0.1)
        gradientView.setGradientBackground(colorOne: bgColor.withAlphaComponent(0.05), colorTwo: bgColor.withAlphaComponent(1.0), colorThree: bgColor.withAlphaComponent(1.0))
        
        
        
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
