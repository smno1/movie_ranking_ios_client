//
//  SearchResultTableViewCell.swift
//  StarBrawl
//
//  Created by yan ShengMing on 16/5/23.
//  Copyright © 2016年 unimelb.student.computing.project. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var filmNameField: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
