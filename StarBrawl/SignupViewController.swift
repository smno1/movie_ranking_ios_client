//
//  SignupViewController.swift
//  StarBrawl
//
//  Created by yan ShengMing on 16/2/29.
//  Copyright © 2016年 unimelb.student.computing.project. All rights reserved.
//

import UIKit
import SwiftyJSON
import Locksmith

class SignupViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordConfirmTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func performSignup(sender: UIButton) {
        let email=emailTextfield.text!
        let password=passwordTextfield.text!
        let passwordCon=passwordConfirmTextfield.text!
        let parameters=[
            "email" : email,
            "password" : password,
            "password_confirmation" :passwordCon
        ]
        AuthenticationService.signUpRequest(parameters, updatedHandler: afterSignUp)
    }
    
    func afterSignUp(response:AnyObject){
        print(response)
        let jtoken=JSON(response)
        if let token=jtoken["auth_token"].string{
            do{
                try Locksmith.updateData(["token" : token], forUserAccount: "StarBrawlToken")
                print("====save email=========")
                print(jtoken["email"].stringValue)
                try Locksmith.updateData(["email" : jtoken["email"].stringValue], forUserAccount: "StarBrawlEmail")
                self.performSegueWithIdentifier("goHome", sender: self)
            }catch{
                print("save token fail")
                AlertHelper.simpleAlert("errors", message: "save token fail", viewController: self)
            }
        }else{
            AlertHelper.simpleAlert("errors", message: jtoken["errors"].dictionaryValue.description, viewController: self)
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
