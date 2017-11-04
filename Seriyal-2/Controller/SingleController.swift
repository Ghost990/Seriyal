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
import CoreImage
import UINavigationBar_Transparent

class SingleController: UIViewController, UIScrollViewDelegate {
    
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
    @IBOutlet weak var singleShowCover: UIImageView!
    @IBOutlet weak var episodesTitleLabel: UILabel!
    @IBOutlet weak var genresTitleLabel: UILabel!
    @IBOutlet weak var runtimeTitleLabel: UILabel!
    @IBOutlet weak var genresInfo: UILabel!
    @IBOutlet weak var runtimeInfo: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextEpisodeOverviewLabel: UILabel!
    @IBOutlet weak var nextEpisodeOverview: UILabel!
    @IBOutlet weak var seriesInfoLabel: UILabel!
    @IBOutlet weak var nextEpisodeTitle: UILabel!
    @IBOutlet weak var episodeSeparator: UIView!
    
    var selectedShowNextEpisodeDate = ""
    var selectedShowTitle = ""
    var selectedShowDescription = ""
    var selectedShowFeaturedImage = ""
    var selectedShowEpisodeButton = ""
    var selectedShowRating = ""
    var selectedShowSeasons = ""
    var selectedShowEpisodes = ""
    var selectedShowSeasonImageUrl = ""
    var selectedShowCoverUrl = ""
    var selectedShowGenres = [String]()
    var selectedShowRuntimes = [String]()
    var selectedShowNextEpisodeOverview = ""
    var selectedShowNextEpisodeTitle = ""
    
    var selectedShowSeasonsArray = [String]()
    var selectedShowLatestEpisodeUrl = ""
    
    var selectedShowNoNewEpisodes = ""
    
    var latestAirDates = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        fillWithData()
        
        //blurEffect()
        
        
        //self.navigationController?.navigationBar.barTintColor = UIColor.clear
        //self.navigationController?.navigationBar.prefersLargeTitles = false
        self.scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        navigationController?.navigationBar.barTintColor = singleShowBackground.backgroundColor
//        navigationController?.navigationBar.tintColor = singleShowTitle.textColor
        
        UIApplication.shared.statusBarStyle = .lightContent
        getExtraInfo()
        colorize()
        self.navigationController?.navigationBar.setBarColor(UIColor.clear)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.setBarColor(UIColor.white)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        let attributes = [
            NSAttributedStringKey.foregroundColor : UIColor.black
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.largeTitleTextAttributes = attributes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //fillWithData()
        //getExtraInfo()
        getLatestEpisodeInfo()
        getExtraInfoPrimary()
        
        
        guard let nextEpisodeAirDate = try latestAirDates.first else {
            //selectedShowNoNewEpisodes = "Already available"
            nextEpisodeButton.setTitle("Season \(self.selectedShowSeasons) available", for: .normal)
            nextEpisodeButton.tag = 1
            print(latestAirDates)
            return
        }
        
        selectedShowNextEpisodeDate = nextEpisodeAirDate
        print(selectedShowNextEpisodeDate)
        
        
        getExtraInfoPrimary()
        calclulateDate()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//
//
//            if self.nextEpisodeButton.titleLabel?.text == "Already available" {
//                self.nextEpisodeButton.setTitle("Season \(self.selectedShowSeasons) available", for: .normal)
//            }
//        }
        
    }
    
    private func getExtraInfoPrimary() {
        
        var genre = self.selectedShowGenres.joined(separator: " | ")
        genresInfo.text = genre
        print(self.selectedShowGenres)
        
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
        print(dateDifferenceUntilShow)
        
        if dateDifferenceUntilShow! == 1 {
            nextEpisodeButton.setTitle("Tomorrow", for: .normal)
        }
        else if (dateDifferenceUntilShow! == 0) {
            nextEpisodeButton.setTitle("Today", for: .normal)
        }
        else if (dateDifferenceUntilShow! > 0) && (dateDifferenceUntilShow! < 7) {
            nextEpisodeButton.setTitle("in \(dateDifferenceUntilShow!) days", for: .normal)
        }
        else {
            nextEpisodeButton.setTitle("\(dateUntilShowLong!)", for: .normal)
        }
        
        //selectedShowNextEpisodeDate = (dateUntilShow?.string(format: .iso8601Auto))!
        
    }
    
    func fillWithData() {
        singleViewDescription.text = selectedShowDescription
        singleShowTitle.text = selectedShowTitle
        //singleShowSeasons.text = selectedShowSeasons
//        nextEpisodeButton.setTitle(selectedShowNextEpisodeDate, for: .normal)
        
        let singleImageUrl = URL(string: selectedShowFeaturedImage)
        singleViewImage.kf.setImage(with: singleImageUrl)
        singleShowCover.kf.setImage(with: singleImageUrl)
        
        
        self.navigationItem.title = selectedShowTitle
        
    }
    
    func blurEffect(style: UIBlurEffect){
        
        let blurEffect = style
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = singleViewImage.bounds
        singleViewImage.addSubview(blurredEffectView)
        
    }
    
    func colorize() {
        
        let showFeaturedImageUrl = URL(string: selectedShowFeaturedImage)
        
        
        ImageDownloader.default.downloadImage(with: showFeaturedImageUrl!, options: [], progressBlock: nil) {
            (image, error, url, data) in
            
            image?.getColors(scaleDownSize: CGSize.init(width: 40, height: 40), completionHandler: { (colors) in

                
                self.nextEpisodeButton.backgroundColor = colors.primary
                self.singleShowEpisodes.textColor = colors.detail
                self.singleShowSeasons.textColor = colors.detail
                self.singleShowRuntime.textColor = colors.detail
                self.singleViewNextEpisodeLabel.textColor = colors.primary
                self.episodesTitleLabel.textColor = colors.detail
                self.genresTitleLabel.textColor = colors.detail
                self.runtimeTitleLabel.textColor = colors.detail
                self.genresInfo.textColor = colors.detail
                self.runtimeInfo.textColor = colors.detail
//                self.nextEpisodeTitle.textColor = colors.primary
//                self.nextEpisodeOverview.textColor = colors.primary
//                self.nextEpisodeOverviewLabel.textColor = colors.primary
                self.seriesInfoLabel.textColor = colors.primary
//                self.episodeSeparator.backgroundColor = colors.primary
                
                self.singleShowBackground.backgroundColor = colors.background
                self.view.backgroundColor = colors.background
                //self.navigationController?.navigationBar.barTintColor = UIColor.clear
                self.gradientView.setGradientBackground(colorOne: colors.background.withAlphaComponent(0.01), colorTwo: colors.background.withAlphaComponent(0.5), colorThree: colors.background.withAlphaComponent(1.0))
                let attributes = [
                    NSAttributedStringKey.foregroundColor : colors.primary
                ]
                self.navigationController?.navigationBar.largeTitleTextAttributes = attributes
                self.navigationController?.navigationBar.tintColor = colors.primary
                self.singleViewDescription.textColor = colors.primary
                
//                self.navigationController?.navigationBar.isTranslucent = true
//                self.navigationController?.view.backgroundColor = UIColor.clear
//                self.navigationController?.navigationBar.barTintColor = UIColor.clear
//                UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//
//                // Sets shadow (line below the bar) to a blank image
//                UINavigationBar.appearance().shadowImage = UIImage()
//                UINavigationBar.appearance().isTranslucent = true
                
//                self.navigationController?.navigationBar.barTintColor = colors.background
                //self.navigationController?.navigationBar.tintColor = colors.primary
                
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
                
                let bgColor = colors.background
                let defaultDarkColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
                
                if (bgColor?.isLight)! {
                    
                    self.blurEffect(style: UIBlurEffect(style: .light))
                } else {
                   
                    self.blurEffect(style: UIBlurEffect(style: .dark))
                }
                
                
                
            })
            
        }
        
        singleShowCover.layer.shadowColor = UIColor.black.cgColor
        singleShowCover.layer.shadowOffset = CGSize(width: 0, height: 2)
        singleShowCover.layer.shadowOpacity = 0.5
        singleShowCover.layer.shadowRadius = 6
        
    }
    
    func getExtraInfo() {

        let api_key = "0b4398f46941f1408547bd8c1f556294"
        let extrasBaseUrl = "https://api.themoviedb.org/3/tv"
        
        var latestSeasonNumberArray = [String]()
        var latestSeasonNumber = latestSeasonNumberArray.last
        var runTime = [String]()
        
        

        var showExtasUrl = "\(extrasBaseUrl)/\(selectedShowId)?api_key=\(api_key)"
        

        Alamofire.request(showExtasUrl).responseJSON { response in

            if response.result.isSuccess {

                print("Success! Got the data")

                let seriesJSON : JSON = JSON(response.result.value!)
                
                let seasonNumber = seriesJSON["number_of_seasons"].stringValue
                let episodeNumber = seriesJSON["number_of_episodes"].stringValue
                let runtimeArray = seriesJSON["episode_run_time"].arrayValue
                let title = seriesJSON["name"].stringValue
                let nextEpisodeDate = seriesJSON["last_air_date"].stringValue
                let seasonsArray = seriesJSON["seasons"].arrayValue
                let genresArray = seriesJSON["genres"].arrayValue
                
                for season in seasonsArray {
                    let seasonNumber = season["season_number"].stringValue
                    latestSeasonNumberArray.append(seasonNumber)
                }
                
                for genre in genresArray {
                    let genreName = genre["name"].stringValue
                    self.selectedShowGenres.append(genreName)
                }
                
                for runtime in runtimeArray {
                    let episodeRuntime = runtime.stringValue
                    runTime.append(episodeRuntime)
                }
                
                //let latestEpisode =
                
                print(seriesJSON["id"].stringValue)
                
                self.singleShowSeasons.text = "\(seasonNumber) Seasons"
                self.singleShowEpisodes.text = "\(episodeNumber) Episodes"
                self.runtimeInfo.text = "\(runTime.first!) minutes"
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
                            let episodeOverview = episode["overview"].stringValue
                            let episodeName = episode["name"].stringValue
                            
                            
//                            self.nextEpisodeTitle.text = episodeName
//                            self.nextEpisodeOverview.text = episodeOverview
                            
                            self.selectedShowNextEpisodeTitle = episodeName
                            self.selectedShowNextEpisodeOverview = episodeOverview
                            
                            let showSingleAirDate = episodeAirDate
                            //self.latestAirDates.append(showSingleAirDate)
                            
                            let today = Date()
                            let dateformatter = DateFormatter()
                            dateformatter.dateFormat = "yyyy-MM-dd"
                            
                            let todayDate = dateformatter.string(from: today)
                            
                            
                            let now = try! DateInRegion(string: "\(todayDate)", format: .custom("yyyy-MM-dd"), fromRegion: Region.Local())
                            let showAiringDate = try! DateInRegion(string: "\(showSingleAirDate)", format: .custom("yyyy-MM-dd"), fromRegion: Region.Local())
                            
                            if showAiringDate! >= now! {
                                self.latestAirDates.append((showAiringDate?.string(custom: "yyyy-MM-dd"))!)
                            }
                            
//                            let leave_dates = self.latestAirDates
//                            let today = Date()
//                            let greaterThanToday = leave_dates.filter { (date) -> Bool in
//                                return CustomDateFormatter.campare(date, with: today)
//                            }
                            //self.latestAirDates = greaterThanToday
                        }
                        
                        
                        print(self.latestAirDates)
                        
                        
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
                
                let showEndDate = showAirDateToCalendar! + 1.hour
                let showEndDateToCalendar = showEndDate
                
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
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //scrollView.contentOffset.y = view.frame.height
        

        self.navigationController?.navigationBar.setBarColor(singleShowBackground.backgroundColor)
        let attributes = [
            NSAttributedStringKey.foregroundColor : nextEpisodeButton.backgroundColor
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        
//        if (scrollView.contentOffset.y > 0.2) {
//
//        }
//        else if (scrollView.contentOffset.y < 0.2) {
//
//        }
        
        
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
