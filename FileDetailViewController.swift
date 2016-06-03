//
//  FileDetailViewController.swift
//  StarBrawl
//
//  Created by yan ShengMing on 16/2/3.
//  Copyright © 2016年 unimelb.student.computing.project. All rights reserved.
//

import UIKit
import SwiftyJSON

class FileDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var film:Film?=nil
    var screen=GlobalHolder.screenSelection
    var currentSelectScreenID=""
    
    @IBOutlet weak var trailerView: UIWebView!

    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dislikeLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var filmPost: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var screenlikeButton: UIButton!
    @IBOutlet weak var screendislikeButton: UIButton!
    @IBOutlet weak var screenlikeLabel: UILabel!
    @IBOutlet weak var screendislikeLabel: UILabel!
    
//    screen picker
    
    @IBOutlet weak var screenPickerField: UITextField!
    var screenPicker=UIPickerView()
    
    @IBOutlet weak var cinemaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(film)
//        screenPickerField
        self.filmPost.image=film?.posters.first?.image
        self.title=film?.name
        self.dislikeLabel.tintColor=UIColor.blueColor()
        self.durationLabel.text=film!.duration
        self.releaseDateLabel.text=film!.released_date
        self.cinemaLabel.text=GlobalHolder.defaultCinema
        DataReceiverUtil.getLikesAndDislikes((film?.id)!, updateHandler: afterGetLikes)
        if let trailerURL:String = film?.trailer_link{
            trailerView.loadHTMLString(trailerURL, baseURL: nil)
            print(trailerURL)
        }
        screenPicker.delegate=self
        screenPicker.dataSource=self
        screenPickerField.inputView=screenPicker
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeScreenPreferenceAvailiable(){
        screenlikeButton.hidden=false
        screendislikeButton.hidden=false
        screenlikeLabel.hidden=false
        screendislikeLabel.hidden=false
    }
    
    @IBAction func clickLike(sender: UIButton) {
        DataReceiverUtil.likeFilm((film?.id)!, updateHandler: afterGetLikes)
    }
    
    @IBAction func clickDislike(sender: UIButton) {
        DataReceiverUtil.dislikeFilm((film?.id)!, updateHandler: afterGetLikes)
    }
    
    @IBAction func clickScreenLike(sender: AnyObject) {
        DataReceiverUtil.likeScreen((film?.id)!,sid:currentSelectScreenID, updateHandler: afterGetScreenLikes)
    }
    
    @IBAction func clickScreenDislike(sender: AnyObject) {
        DataReceiverUtil.dislikeScreen((film?.id)!,sid: currentSelectScreenID, updateHandler: afterGetScreenLikes)
    }
    
    func afterGetLikes(response: AnyObject){
        print(response)
        var jresp=JSON(response)
        likeLabel.text=jresp["likes"].stringValue
        dislikeLabel.text=jresp["dislikes"].stringValue
        if jresp["like_by_me"]==1 {
            dispatch_async(dispatch_get_main_queue(), {
                self.likeLabel.textColor=UIColor.blueColor()
            })
        }else{
            self.likeLabel.textColor=UIColor.blackColor()
        }
        if jresp["dislike_by_me"]==1 {
            dispatch_async(dispatch_get_main_queue(), {
                self.dislikeLabel.textColor=UIColor.blueColor()
            })
        }else{
            self.dislikeLabel.textColor=UIColor.blackColor()
        }
        
    }
    func afterGetScreenLikes(response: AnyObject){
        print(response)
        var jresp=JSON(response)
        screenlikeLabel.text=jresp["likes"].stringValue
        screendislikeLabel.text=jresp["dislikes"].stringValue
        if jresp["like_by_me"]==1 {
            dispatch_async(dispatch_get_main_queue(), {
                self.screenlikeLabel.textColor=UIColor.blueColor()
            })
        }else{
            self.screenlikeLabel.textColor=UIColor.blackColor()
        }
        if jresp["dislike_by_me"]==1 {
            dispatch_async(dispatch_get_main_queue(), {
                self.screendislikeLabel.textColor=UIColor.blueColor()
            })
        }else{
            self.screendislikeLabel.textColor=UIColor.blackColor()
        }
        
    }

    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return screen.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        screenPickerField.text=screen[row].name
        currentSelectScreenID=screen[row].id!
        view.endEditing(true)
        makeScreenPreferenceAvailiable()
        DataReceiverUtil.getScreenLikesAndDislikes((film?.id)!,sid:screen[row].id!, updateHandler:afterGetScreenPreference )
    }
    
    func afterGetScreenPreference(response: AnyObject){
        print(response)
        var jresp=JSON(response)
        screenlikeLabel.text=jresp["likes"].stringValue
        screendislikeLabel.text=jresp["dislikes"].stringValue
        if jresp["like_by_me"]==1 {
            dispatch_async(dispatch_get_main_queue(), {
                self.screenlikeLabel.textColor=UIColor.blueColor()
            })
        }else{
            self.screenlikeLabel.textColor=UIColor.blackColor()
        }
        if jresp["dislike_by_me"]==1 {
            dispatch_async(dispatch_get_main_queue(), {
                self.screendislikeLabel.textColor=UIColor.blueColor()
            })
        }else{
            self.screendislikeLabel.textColor=UIColor.blackColor()
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return screen[row].name
    }
//    func updateLikeNumber(response:AnyObject){
//        print(response)
//        var jresp=JSON(response)
//        likeLabel.text=jresp["likes"].stringValue
//
//    }
//    func updateDislikeNumber(response:AnyObject){
//        print(response)
//        var jresp=JSON(response)
//        dislikeLabel.text=jresp["dislikes"].stringValue
//
//    }


}
