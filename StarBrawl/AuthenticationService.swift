//
//  AuthenticationService.swift
//  StarBrawl
//
//  Created by yan ShengMing on 16/2/26.
//  Copyright © 2016年 unimelb.student.computing.project. All rights reserved.
//

import Foundation
import Locksmith
import Alamofire

class AuthenticationService{
    class func signInRequest(parameters:[String:AnyObject],updatedHandler:AnyObject->Void){
        DataReceiverUtil.postRequest("sessions", parameters: parameters, completedHandler: updatedHandler)
    }
    class func checkIfUserSignIn(completedHandler:AnyObject->Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount("StarBrawlToken") else{
            return
        }
        
        if let token=dictionary["token"] as? String{
            let headers = [
                "Authorization": token
            ]
            
            Alamofire.request(.GET, DataReceiverUtil.baseUrl+"is_user_sign_in", headers: headers)
                .responseJSON { response in
                    print(response)
                    if let value=response.result.value {
                        completedHandler(value)
                    }
            }
        }
    }
    class func signUpRequest(parameters:[String:AnyObject],updatedHandler:AnyObject->Void){
        DataReceiverUtil.postRequest("users", parameters: parameters, completedHandler: updatedHandler)
    }
    
    class func logoutRequest(updatedHandler:AnyObject->Void){
        guard let dictionary = Locksmith.loadDataForUserAccount("StarBrawlToken") else{
            return
        }
        
        if let token=dictionary["token"] as? String{
            let headers = [
                "Authorization": token
            ]
            
            Alamofire.request(.DELETE, DataReceiverUtil.baseUrl+"sessions/delete", headers: headers)
                .responseJSON { response in
                    print(response)
                    if let value=response.result.value {
                        updatedHandler(value)
                    }
            }
        }
    }
}