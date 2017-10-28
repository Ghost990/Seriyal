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
    
    var selectedShowTitle = ""
    var selectedShowDescription = ""
    var selectedShowFeaturedImage = ""
    var selectedShowEpisodeButton = ""
    var selectedShowRating = ""
    var selectedShowSeasons = ""
    var selectedShowEpisodes = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getExtraInfo()
        fillWithData()
        colorize()
        
        singleShowSeasons.text = selectedShowSeasons

        //self.navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        navigationController?.navigationBar.barTintColor = singleShowBackground.backgroundColor
        navigationController?.navigationBar.tintColor = singleShowTitle.textColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillWithData() {
        singleViewDescription.text = selectedShowDescription
        singleShowTitle.text = selectedShowTitle
        singleShowSeasons.text = selectedShowSeasons
        
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

        var showExtasUrl = "\(extrasBaseUrl)/\(selectedShowId)?api_key=\(api_key)"

        Alamofire.request(showExtasUrl).responseJSON { response in

            if response.result.isSuccess {

                print("Success! Got the data")

                let seriesJSON : JSON = JSON(response.result.value!)
                
                let seasonNumber = seriesJSON["number_of_seasons"].stringValue
                let episodeNumber = seriesJSON["number_of_episodes"].stringValue
                let runtime = seriesJSON["episode_run_time"].stringValue
                print(runtime)
                
                self.singleShowSeasons.text = "\(seasonNumber) Seasons"
                self.singleShowEpisodes.text = "\(episodeNumber) Episodes"
                self.singleShowRuntime.text = "Runtime: \(runtime)"

            } else {
                print("Error \(String(describing: response.result.error))")
            }


        }

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
