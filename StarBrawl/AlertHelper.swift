//
//  AlertHelper.swift
//  StarBrawl
//
//  Created by yan ShengMing on 16/2/29.
//  Copyright © 2016年 unimelb.student.computing.project. All rights reserved.
//

import UIKit

class AlertHelper{
    class func simpleAlert(title:String,message:String,viewController:UIViewController){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        viewController.presentViewController(alertView, animated: true, completion: nil)
    }
}