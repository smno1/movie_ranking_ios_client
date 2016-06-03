//
//  ProfileViewController.swift
//  StarBrawl
//
//  Created by yan ShengMing on 16/2/29.
//  Copyright © 2016年 unimelb.student.computing.project. All rights reserved.
//

import UIKit
import Locksmith
import SwiftyJSON

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var cinemaPickerField: UITextField!
    @IBOutlet weak var myLikedTableView: UITableView!
    @IBOutlet weak var usermailField: UILabel!
    var cinemaPicker=UIPickerView()
    
    var myFilms=[Film]()
    var cinemas=[Cinema]()
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let dictionary = Locksmith.loadDataForUserAccount("StarBrawlEmail") else{
            return
        }
        if let usermail=dictionary["email"] as? String{
            usermailField.text="Login as "+usermail
        }
        cinemaPicker.delegate=self
        cinemaPicker.dataSource=self
        cinemaPickerField.inputView=cinemaPicker
        DataReceiverUtil.getCinemas(afterGotCinemas)
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(tap)
    }
//    //Calls this function when the tap is recognized.
//    func dismissKeyboard() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        view.endEditing(true)
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        DataReceiverUtil.getMyFilms(afterGetMyFilms)
    }
    
    @IBAction func performLogout(sender: AnyObject) {
        AuthenticationService.logoutRequest(afterLogout)
    }
    
    func afterGotCinemas(rcinemas:AnyObject){
        cinemas.removeAll()
        var cname=""
        let jcinemas=JSON(rcinemas)
        for (_, c):(String, JSON) in jcinemas{
            let cin = Cinema()
            cin.name=c["name"].stringValue
            cin.id=c["id"].stringValue
            cin.description=c["description"].stringValue
            cinemas.append(cin)
            if(GlobalHolder.myPreferCinema==cin.id){
                cname=cin.name!
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.cinemaPickerField.text=cname
            self.cinemaPicker.reloadAllComponents()
        })
    }
    
    func afterGetMyFilms(films:AnyObject){
        myFilms.removeAll()
        let jfilms=JSON(films)
        for (_, f):(String, JSON) in jfilms{
            let film = Film()
            film.name=f["name"].stringValue
            film.id=f["id"].stringValue
            film.duration=f["duration"].stringValue
            film.released_date=f["released_date"].stringValue
            film.trailer_link=f["trailer_link"].stringValue
            let posters=f["posters"].arrayValue
            for poster:JSON in posters{
                var p=Poster()
                p.image_url=poster["image_url"].string
//                if let url=p.image_url{
//                    let url1:NSURL=NSURL(string: url)!
//                    let data:NSData? = NSData(contentsOfURL : url1)
//                    p.image = UIImage(data : data!)
//                }
                p.title=poster["title"].stringValue
                film.posters.append(p)
            }
            
            myFilms.append(film)
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.myLikedTableView.reloadData()
        })
    }
    func afterLogout(response:AnyObject){
        print(response)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("loginViewController") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myFilms.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.performSegueWithIdentifier("toDetail", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilmCell", forIndexPath: indexPath) as! MyFilmTableViewCell
        
        // Configure the cell...
        let film=myFilms[indexPath.row]
        cell.filmNameField.text=film.name
        cell.releaseDate.text=film.released_date
        return cell
    }

    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return cinemas.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cinemaPickerField.text=cinemas[row].name
        view.endEditing(true)
        GlobalHolder.myPreferCinema=cinemas[row].id!;
        GlobalHolder.defaultCinema=cinemas[row].name!
        DataReceiverUtil.updateMyCinema(cinemas[row].id!, updateHandler: afterPicker)
    }
    
    func afterPicker(response:AnyObject){
        print(response)
        GlobalHolder.homeControllerFreshFlag=true;
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cinemas[row].name
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toDetail") {
        let destinationVC = segue.destinationViewController as! FileDetailViewController
            let index = (sender as! NSIndexPath).row
            let film=myFilms[index]
            print(film)
            if let url=film.posters.first?.image_url{
                let url1:NSURL=NSURL(string: url)!
                let data:NSData? = NSData(contentsOfURL : url1)
                film.posters.first!.image = UIImage(data : data!)
            }
            destinationVC.film = film
        }
    }
}
