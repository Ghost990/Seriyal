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
    var singleShowImageUrl = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fillWithInfo()
        colorize()
        //self.navigationController?.navigationBar.setBarColor(UIColor.clear)
        navigationController?.navigationBar.barTintColor = UIColor.red
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.navigationController?.navigationBar.setBarColor(singleShowBackground.backgroundColor)
        let attributes = [
            NSAttributedStringKey.foregroundColor : nextEpisodeButton.backgroundColor
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    private func fillWithInfo() {
        fetcher.fetchForSingle(id: singleShowId)
        let showTitle = fetcher.showTitle
        let showImageUrl = fetcher.showImageUrl
        let showDescription = fetcher.showDescription
        let singleImageUrl = URL(string: showImageUrl)
        
        singleShowImageUrl = showImageUrl
        
        self.navigationItem.title = showTitle
        singleViewDescription.text = showDescription
        singleViewImage.kf.setImage(with: singleImageUrl, options: [.transition(.fade(0.2))])
        singleShowCover.kf.setImage(with: singleImageUrl, options: [.transition(.fade(0.2))])
    }
    
    func blurEffect(style: UIBlurEffect){
        let blurEffect = style
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = singleViewImage.bounds
        singleViewImage.addSubview(blurredEffectView)
    }
    
    func colorize() {
        let show = SeriesCore()
        let singleImageUrl = URL(string: singleShowImageUrl)
        
        let image = singleImageUrl
        ImageDownloader.default.downloadImage(with: singleImageUrl!, options: [], progressBlock: nil) {
            (image, error, url, data) in
            
            image?.getColors(scaleDownSize: CGSize.init(width: 40, height: 40), completionHandler: { (colors) in
                
                self.singleShowBackground.backgroundColor = colors.background
                self.nextEpisodeButton.backgroundColor = colors.primary
                self.singleViewDescription.textColor = colors.secondary
                self.singleViewNextEpisodeLabel.textColor = colors.secondary
                let attributes = [
                    NSAttributedStringKey.foregroundColor : colors.primary
                ]
                self.navigationController?.navigationBar.largeTitleTextAttributes = attributes
                self.navigationController?.navigationBar.titleTextAttributes = attributes
                self.navigationController?.navigationBar.tintColor = colors.primary
                
                let backgroundColor = colors.background
                let buttonColor = colors.primary
                
                if (buttonColor?.isLight)! {
                    self.nextEpisodeButton.setTitleColor(UIColor.black, for: .normal)
                }
                else {
                    self.nextEpisodeButton.setTitleColor(UIColor.white, for: .normal)
                }
                
                if (backgroundColor?.isLight)! {
                    self.blurEffect(style: UIBlurEffect(style: .light))
                }
                else {
                    self.blurEffect(style: UIBlurEffect(style: .dark))
                }
            })
        }
        singleShowCover.layer.shadowColor = UIColor.black.cgColor
        singleShowCover.layer.shadowOffset = CGSize(width: 0, height: 2)
        singleShowCover.layer.shadowOpacity = 0.5
        singleShowCover.layer.shadowRadius = 6
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.singleShowCover.layer.cornerRadius = 2
    }
    
}


