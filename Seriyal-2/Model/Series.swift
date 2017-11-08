//
//  Series.swift
//  Seriyal
//
//  Created by Zsolt Nagy on 2017. 10. 13..
//  Copyright © 2017. Zsolt Nagy. All rights reserved.
//

import Foundation

//var showList : [Series] = [Series]()


class Series: HashableClass {
    
    
    var id: String = ""
    var imageURL: String = ""
    var title: String = ""
    var seasonsNumber: String = ""
    var episodesNumber: String = ""
    var description: String = ""
    var featuredImageUrl : String = ""
    var genres = [String]()
    var latestSeasonImageUrl : String = ""
    
    func updateSeries() {
        
        
        
        //self.title = api.showTitle
        //print(self.title)
        
        
    }

}



