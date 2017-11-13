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
    
    
    
    var singleShowId = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}


