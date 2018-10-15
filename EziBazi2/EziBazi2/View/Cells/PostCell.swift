//
//  SearchPostCell.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/10/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postTitle: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var postCreation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
