//
//  FoodCell.swift
//  PullToRefereach
//
//  Created by Nigel.He on 16/11/15.
//  Copyright © 2016年 User. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {

    @IBOutlet weak var foodIcon: UIImageView!
    
    @IBOutlet weak var foodName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
