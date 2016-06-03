//
//  HomeViewController.swift
//  StarBrawl
//
//  Created by yan ShengMing on 15/12/6.
//  Copyright © 2015年 unimelb.student.computing.project. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {
    var onSceneFilms=[Film]()
    var myRefreshControl:UIRefreshControl!
    @IBOutlet weak var filmsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myRefreshControl = UIRefreshControl()
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 210.0/255.0, green: 215.0/255.0, blue: 211.0/255.0, alpha: 0.8)
        myRefreshControl.addTarget(self, action: Selector("updateFilms"), forControlEvents: UIControlEvents.ValueChanged)
        self.filmsCollectionView.addSubview(myRefreshControl)
        if(GlobalHolder.myPreferCinema==""){
            DataReceiverUtil.getOnScreen(updateFilms)
        }else{
//            DataReceiverUtil.getOnScreen(updateFilms)
            DataReceiverUtil.getCinemaFilms(GlobalHolder.myPreferCinema,updatedHandler: updateFilms)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if(GlobalHolder.homeControllerFreshFlag){
            GlobalHolder.homeControllerFreshFlag=false;
//            DataReceiverUtil.getOnScreen(updateFilms)
            DataReceiverUtil.getCinemaFilms(GlobalHolder.myPreferCinema,updatedHandler: updateFilms)
        }
    }
    
    func updateFilms(films:AnyObject){
        onSceneFilms.removeAll()
        let jfilms=JSON(films)
        print(jfilms)
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
                if let url=p.image_url{
                    let url1:NSURL=NSURL(string: url)!
                    let data:NSData? = NSData(contentsOfURL : url1)
                    p.image = UIImage(data : data!)
                }
                p.title=poster["title"].stringValue
                film.posters.append(p)
            }
            
            //film.
            onSceneFilms.append(film)
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.filmsCollectionView.reloadData()
        })
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //override collection method
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return onSceneFilms.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("RecentFilmCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        cell.film=onSceneFilms[indexPath.row]
//        let filmCellContent=onSceneFilms[indexPath.row]
//        if filmCellContent.posters.count>0{
//            cell.imageField.image=filmCellContent.posters[0].image
//            cell.titleField.text=filmCellContent.name
//        }
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a new variable to store the instance of TableViewController
        let cell: ImageCollectionViewCell = sender as! ImageCollectionViewCell
        let destinationVC = segue.destinationViewController as! FileDetailViewController
        if let index = filmsCollectionView.indexPathForCell(cell)?.row {
            destinationVC.film = onSceneFilms[index]
        }
    }

}
