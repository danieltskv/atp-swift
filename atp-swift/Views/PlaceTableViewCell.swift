//
//  PlaceTableViewCell.swift
//  atp-swift
//
//  Created by Daniel Tsirulnikov on 22.7.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import UIKit
import SDWebImage.UIImageView_WebCache

class PlaceTableViewCell: UITableViewCell {

    // MARK: - Properties

    var place: Place? {
        didSet {
            self.setupPlace()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var line1View: UIView!
    @IBOutlet weak var line2View: UIView!

    // MARK: - Override

    override func prepareForReuse() {
        self.place = nil
        self.titleLabel.text = nil
        self.subtitleLabel.text = nil
        self.placeImageView.image = nil
        self.line1View.hidden = false
        self.line2View.hidden = false
    }
    
    // MARK: - Convenience

    func setupPlace() {
        guard let place = place else {
            return
        }
        
        titleLabel.text = place.name ?? ""
        //subtitleLabel.text = "10:00"
        
        if place.imageURL != nil {
            placeImageView.sd_setImageWithURL(place.imageURL)
        }
    }

}
