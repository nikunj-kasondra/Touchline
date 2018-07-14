//
//  tblCell.swift
//  tableDemo
//
//  Created by Nikunj on 3/15/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit
import GoogleMobileAds

class tblCell: UITableViewCell {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var adsHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblClub: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var dateWidth: NSLayoutConstraint!
    @IBOutlet weak var flagImg: RemoteImageView!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblAwayTeam: UILabel!
    
    @IBOutlet weak var lblHomeTeam: UILabel!
    
    @IBOutlet weak var lblTip: UILabel!
    
    @IBOutlet weak var lblScoreAway: UILabel!
    
    @IBOutlet weak var lblOdd: UILabel!
    
    @IBOutlet weak var lblScroeHome: UILabel!
    
    
    @IBOutlet weak var tipwidthCons: NSLayoutConstraint!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
