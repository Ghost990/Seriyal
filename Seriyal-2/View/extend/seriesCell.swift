//
//  seriesCell.swift
//  Seriyal-2
//
//  Created by Zsolt Nagy on 2017. 10. 23..
//  Copyright © 2017. Zsolt Nagy. All rights reserved.
//

import UIKit

class seriesCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellSummary: UILabel!
    
    @IBOutlet weak var cellWholeView: UIView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
        cellWholeView.layer.cornerRadius = 6.0
        cellWholeView.layer.shadowColor = UIColor.black.cgColor
        cellWholeView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cellWholeView.layer.shadowOpacity = 0.2
        cellWholeView.layer.shadowRadius = 4
        

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
