//
//  DataReceiver.swift
//  StarBrawl
//
//  Created by yan ShengMing on 15/12/7.
//  Copyright © 2015年 unimelb.student.computing.project. All rights reserved.
//

import Foundation
import Alamofire
import Locksmith

class DataReceiverUtil {
    static let baseUrl:String = "http://movie-rank-data.herokuapp.com/api/v1/"
//    static let baseUrl:String = "http://localhost:3000/api/v1/"
    class func getData(api : String, updatedHandler: AnyObject->Void) {
        let urlString=baseUrl+api
        Alamofire.request(.GET,urlString)
            .responseJSON{response in
                print(response)
                if let value=response.result.value {
                    updatedHandler(value)
                }
        }
    }
    class func getDataWithHeaderAndParameters(api : String, parameters:[String: AnyObject]?=nil,headers:[String:String]?=nil,updatedHandler: AnyObject->Void) {
        let urlString=baseUrl+api
        Alamofire.request(.GET,urlString,parameters: parameters,headers:headers)
            .responseJSON{response in
                print(response)
                if let value=response.result.value {
                    updatedHandler(value)
                }
        }
    }
    
    class func postRequest(api: String,parameters:[String: AnyObject], completedHandler: AnyObject->Void){
        let urlString=baseUrl+api
        Alamofire.request(.POST, urlString,parameters: parameters)
            .responseJSON{ response in
                if let value=response.result.value {
                    completedHandler(value)
                }
        }
    }
    
    class func postRequestWithHeader(api: String,parameters:[String: AnyObject],headers:[String:String], completedHandler: AnyObject->Void){
        let urlString=baseUrl+api
        Alamofire.request(.POST, urlString,parameters: parameters,headers:headers)
            .responseJSON{ response in
                if let value=response.result.value {
                    completedHandler(value)
                }
        }
    }
    
    class func getOnScreen(updatedHandler: AnyObject-> Void) {
        self.getData("films/on_screen",updatedHandler: updatedHandler)
    }
    
    class func getCinemaFilms(id:String, updatedHandler: AnyObject-> Void) {
        let parameters=[
            "id":id
        ]
        self.getDataWithHeaderAndParameters("cinemas/current_films",parameters:parameters,updatedHandler: updatedHandler)
    }
    
    class func getCinemas(updatedHandler: AnyObject->Void){
        self.getData("cinemas",updatedHandler: updatedHandler)
    }
    
    class func getHeaderParameter()->[String:String]? {
        guard let dictionary = Locksmith.loadDataForUserAccount("StarBrawlToken") else{
            return nil
        }
        if let token=dictionary["token"] as? String{
            let headers = [
                "Authorization": token
            ]
            return headers
        }
        return nil
    }
    
    class func getMyFilms(updateHandler:AnyObject->Void){
        if let headers=getHeaderParameter() as [String:String]?{
            self.getDataWithHeaderAndParameters("my_liked_films", headers:headers, updatedHandler: updateHandler)
        }
    }
    
    class func searchFilm(keyWord:String,updateHandler: AnyObject->Void) {
        let parameters=[
            "contain_word":keyWord
        ]
        if let headers=getHeaderParameter() as [String:String]?{
            self.postRequestWithHeader("search_films", parameters:parameters,headers:headers, completedHandler: updateHandler)
        }
    }
    
    class func likeFilm(fid:String,updateHandler: AnyObject->Void) {
        let parameters=[
            "film_id":fid
        ]
        if let headers=getHeaderParameter() as [String:String]?{
            self.postRequestWithHeader("like", parameters:parameters,headers:headers, completedHandler: updateHandler)
        }
    }
    class func dislikeFilm(fid:String,updateHandler: AnyObject->Void) {
        let parameters=[
            "film_id":fid
        ]
        if let headers=getHeaderParameter() as [String:String]?{
            self.postRequestWithHeader("dislike", parameters:parameters,headers:headers, completedHandler: updateHandler)
        }
    }
    
    class func likeScreen(fid:String,sid:String,updateHandler: AnyObject->Void) {
        let parameters=[
            "screen_id":sid,
            "film_id":fid
        ]
        if let headers=getHeaderParameter() as [String:String]?{
            self.postRequestWithHeader("screen_like", parameters:parameters,headers:headers, completedHandler: updateHandler)
        }
    }
    class func dislikeScreen(fid:String,sid:String,updateHandler: AnyObject->Void) {
        let parameters=[
            "screen_id":sid,
            "film_id":fid
        ]
        if let headers=getHeaderParameter() as [String:String]?{
            self.postRequestWithHeader("screen_dislike", parameters:parameters,headers:headers, completedHandler: updateHandler)
        }
    }
    class func getLikesAndDislikes(fid:String,updateHandler:AnyObject->Void) {
        let parameters=[
            "film_id":fid
        ]
        if let headers=getHeaderParameter() as [String:String]?{
            self.getDataWithHeaderAndParameters("likes_and_dislikes", parameters:parameters,headers:headers, updatedHandler: updateHandler)
        }

    }
    class func getScreenLikesAndDislikes(fid:String,sid:String,updateHandler:AnyObject->Void) {
        let parameters=[
            "screen_id":sid,
            "film_id":fid
        ]
        if let headers=getHeaderParameter() as [String:String]?{
            self.getDataWithHeaderAndParameters("screen_preference", parameters:parameters,headers:headers, updatedHandler: updateHandler)
        }
        
    }

    
    
    class func updateMyCinema(cid:String,updateHandler:AnyObject->Void){
        let parameters=[
            "cinema_id":cid
        ]
        if let headers=getHeaderParameter() as [String:String]?{
            self.postRequestWithHeader("set_default_cinema", parameters:parameters,headers:headers, completedHandler: updateHandler)
        }
    }
    
    
    class func testNSURLSessionCallApi(){
        print ("start request")
        let url = NSURL(string: "http://movie-rank-data.herokuapp.com/api/v1/films/on_screen")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            print("data string: ")
            let dataString=NSString(data: data!, encoding: NSUTF8StringEncoding)
            //            try! dataString?.writeToFile("test.txt", atomically: true, encoding: NSUTF8StringEncoding)
            print(dataString)
        }
        task.resume()
    }

    
    
    
}