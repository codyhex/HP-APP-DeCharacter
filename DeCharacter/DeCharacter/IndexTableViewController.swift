//
//  IndexTableViewController.swift
//  HanZiBreaker
//
//  Created by HePeng on 7/31/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import UIKit

struct Identifiers {
    static let basicSegue = "select radical segue"
    static let basicCell = "index character cell"
    static let possibleRadicalsSegue = "possible radicals segue"
    static let radicalMeaningsSegue = "radical meanings segue"
    static let reuseIdentifier = "radical cell"
}

class IndexTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var mostRecentMoreInfo: String? {
        didSet {
            // Whenever the model changes AFTER the first time the view is shown on
            // screen, you must do this
            // setNeedsDisplay() does not do it
            tableView.reloadData()
        }
    }
    
    var wordList: NSDictionary! = nil
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        wordList = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("word list", withExtension: "plist")!)
        
    }
    /////////////// Table View Initilization //////////////////////
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return wordList.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (wordList.allValues[section] as! NSArray).count
    }
    
    func makeSubviewName(indexPath: NSIndexPath) -> String {
        return "#\((wordList.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row)[0])"
    }
    
    func getChineseName(indexPath: NSIndexPath) -> String {
        return "\((wordList.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row)[1])"
    }
    
    func getFourCornerCode(indexPath: NSIndexPath) -> String {
        return "\((wordList.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row)[2])"
    }
    
    // prepareCellForRendering
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.basicCell, forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = makeSubviewName(indexPath)
        cell.textLabel?.font = UIFont .boldSystemFontOfSize(25)
        
        /* @@HP: when adding the image, there is a "title" word shows between the image and word. Dob't know how to fix it */
        var imageName = ((wordList.allValues[indexPath.section] as! NSArray).objectAtIndex(indexPath.row)[1] as? String)!
        let image = UIImage(named: imageName)
        cell.imageView?.image = image
        let highlightedImage = UIImage(named: imageName + "_RC")
        cell.imageView?.highlightedImage = highlightedImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return wordList.allKeys[section] as? String
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        println("\((wordList.allValues[indexPath.section] as? NSArray)?.objectAtIndex(indexPath.row)) Selected")
//    }
    
    // MARK: - Navigation
    // Segue: Transition from one full-screen view to another where user is "diving deeper"
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier ?? "MISSING" {
        case Identifiers.basicSegue:
            // figure out which row of the table we're transitioning from
            
            // tableView property is initialized by TableViewController and knows
            // where the user just tapped.
            if let indexPath = tableView.indexPathForSelectedRow() {
                // now need to look up the RadicalsViewController instance
                if let radicalVC = segue.destinationViewController as? RadicalsViewController {
                    // finally we have the handle on the view we need to prepare
                    // and we have a handle on the data from "indexPath"
                    // This is the big moment that connects the data from parent to child
                    radicalVC.title = "\(getChineseName(indexPath))"
                    radicalVC.chineseName = getChineseName(indexPath)
                    radicalVC.FCCode = getFourCornerCode(indexPath)
                    radicalVC.identifier = makeSubviewName(indexPath)
                    
                    
                    //...in a realistic scenario, the right side is a lookup, based on
                    // the indexPath's section & row, into a substantial data model
                    
                    //... and the left side may be a number of assignments because
                    // the detail view actually has a lot of detail
                }
                else {
                    assertionFailure("destination of segue was not a RadicalsViewController!")
                }
            }
            else {
                assertionFailure("prepareForSegue called when no row selected")
            }
        default:
            assertionFailure("unknown segue ID \(segue.identifier)")
        }
    }
    
    
}
