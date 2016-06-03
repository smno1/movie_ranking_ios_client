//
//  Screen.swift
//  StarBrawl
//
//  Created by yan ShengMing on 16/5/22.
//  Copyright © 2016年 unimelb.student.computing.project. All rights reserved.
//

import Foundation
import SwiftyJSON
class Screen {
    var id:String?=nil
    var name:String?=nil
    class func getScreens(screens:[JSON])->[Screen]{
        var screenLst:[Screen]=[];
        if screens.isEmpty {return [];}
        for s in screens {
            var screen=Screen()
            screen.id=s["id"].stringValue
            screen.name=s["number"].stringValue
            screenLst.append(screen)
        }
        print(screenLst)
        return screenLst
    }
}