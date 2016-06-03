//
//  LoginViewController.swift
//  StarBrawl
//
//  Created by yan ShengMing on 16/2/25.
//  Copyright © 2016年 unimelb.student.computing.project. All rights reserved.
//

import UIKit
import Locksmith
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthenticationService.checkIfUserSignIn(ifSigninDo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Login(sender: UIButton) {
        //TO DO: make request and save token
        let email=usernameField.text!
        let password=passwordField.text!
        let parameters=[
            "session" :[
                "email" : email,
                "password" : password
            ]
        ]
        AuthenticationService.signInRequest(parameters, updatedHandler: afterSignin)
    }
    
    func ifSigninDo(response: AnyObject){
        guard let error=response["errors"] as? String else{
            print("============Already Sign in============")
            let jtoken=JSON(response)
            GlobalHolder.myPreferCinema=jtoken["cinema_id"].stringValue;
            GlobalHolder.screenSelection=Screen.getScreens(jtoken["default_cinema_screen"].arrayValue)
            GlobalHolder.defaultCinema=jtoken["default_cinema"]["name"].stringValue
            self.performSegueWithIdentifier("goHome", sender: self)
            return
        }
        print(error)
    }
    
    func afterSignin(response:AnyObject){
        print(response)
        let jtoken=JSON(response)
        if let token=jtoken["auth_token"].string{
            do{
                try Locksmith.updateData(["token" : token], forUserAccount: "StarBrawlToken")
                try Locksmith.updateData(["email" : jtoken["email"].stringValue], forUserAccount: "StarBrawlEmail")
                GlobalHolder.myPreferCinema=jtoken["cinema_id"].stringValue;
                GlobalHolder.screenSelection=Screen.getScreens(jtoken["default_cinema_screen"].arrayValue)
                GlobalHolder.defaultCinema=jtoken["default_cinema"]["name"].stringValue
                self.performSegueWithIdentifier("goHome", sender: self)
            }catch{
                print("save token fail")
                AlertHelper.simpleAlert("errors", message: "save token fail", viewController: self)
            }
        }else{
            print(jtoken["errors"].stringValue)
            AlertHelper.simpleAlert("errors", message: jtoken["errors"].stringValue, viewController: self)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
