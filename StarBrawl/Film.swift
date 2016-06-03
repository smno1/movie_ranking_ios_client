//
//  Film.swift
//  StarBrawl
//
//  Created by yan ShengMing on 15/12/6.
//  Copyright © 2015年 unimelb.student.computing.project. All rights reserved.
//

import Foundation

class Film{
    var id:String?=nil
    var name:String?=nil
    var description:String?=nil
    var released_date:String?=nil
    var trailer_link:String?=nil
    var online:Bool?=nil
    var category:String?=nil
    var duration:String?=nil
    var posters = [Poster]()
}