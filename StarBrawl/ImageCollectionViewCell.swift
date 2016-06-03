//
//  ImageCollectionViewCell.swift
//  StarBrawl
//
//  Created by yan ShengMing on 15/12/7.
//  Copyright © 2015年 unimelb.student.computing.project. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var film: Film!{
        didSet{
            updateUI()
        }
    }
    
    //@IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var imageField: UIImageView!
    
    private func updateUI(){
        if film.posters.count>0{
            self.imageField.image=film.posters[0].image
        }
        //self.titleField.text=film.name
    }
}
