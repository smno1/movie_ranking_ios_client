//
//  SearchViewController.swift
//  StarBrawl
//
//  Created by yan ShengMing on 16/5/23.
//  Copyright © 2016年 unimelb.student.computing.project. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var filmSearchBar: UISearchBar!
    @IBOutlet weak var searchResultTable: UITableView!
    var resultFilms=[Film]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultFilms.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.performSegueWithIdentifier("toDetail", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resultFilmCell", forIndexPath: indexPath) as! SearchResultTableViewCell
        
        // Configure the cell...
        let film=resultFilms[indexPath.row]
        cell.filmNameField.text=film.name
        cell.releaseDate.text=film.released_date
        return cell
    }
    
    func searchBarSearchButtonClicked(filmSearchBar: UISearchBar){
        print(filmSearchBar.text)
        DataReceiverUtil.searchFilm(filmSearchBar.text!, updateHandler: afterGetResults)
        view.endEditing(true)
    }
    
    func afterGetResults(films:AnyObject){
        resultFilms.removeAll()
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
            
            resultFilms.append(film)
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.searchResultTable.reloadData()
        })

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toDetail") {
            let destinationVC = segue.destinationViewController as! FileDetailViewController
            let index = (sender as! NSIndexPath).row
            let film=resultFilms[index]
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
