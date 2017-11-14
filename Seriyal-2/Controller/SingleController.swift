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
import CoreData


class SingleController: UIViewController, UIScrollViewDelegate {
    
    let fetcher = Fetcher()
    @IBOutlet weak var singleViewImage: UIImageView!
    @IBOutlet weak var singleViewDescription: UILabel!
    @IBOutlet weak var nextEpisodeButton: UIButton!
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
    @IBOutlet weak var seriesInfoLabel: UILabel!
    
    var singleShowId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillWithInfo()
        self.scrollView.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fillWithInfo() {
        fetcher.fetchForSingle(id: singleShowId)
        let showTitle = fetcher.showTitle
        let showImageUrl = fetcher.showImageUrl
        let showDescription = fetcher.showDescription
        let singleImageUrl = URL(string: showImageUrl)
        
        self.navigationItem.title = showTitle
        singleViewDescription.text = showDescription
        singleViewImage.kf.setImage(with: singleImageUrl)
        singleShowCover.kf.setImage(with: singleImageUrl)
    }
    
    func blurEffect(style: UIBlurEffect){
        let blurEffect = style
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = singleViewImage.bounds
        singleViewImage.addSubview(blurredEffectView)
    }
    
}


