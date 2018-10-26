//
//  ImageCell.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/8/24.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit

class ImageCell: MediaCollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        image.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        image.layer.borderWidth = 1
    }

    @IBAction func onDelete(_ sender: Any) {
        delegate?.onDelete(sender: self)
    }
    
    override func setCanDelete(canDelete: Bool) {
        btnDelete.isHidden = !canDelete
    }
}
