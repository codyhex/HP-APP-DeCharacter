//
//  SearchRadicalsViewController.swift
//  HanZiBreaker
//
//  The searching process happens here. Use the arguments passed in to look up the radicals.
//  Let the user select the final radical and then use the radical character as the search key to search in parse.com and retriee the link
//  Display a website with the link in an UIWeb view in next page
//
//  Created by HePeng on 8/2/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import UIKit

let PAGE_404_URL = "http://thinkinbath.com/404/"

struct RadicalProperties {
    static let WikiID = 0
    static let pinyin = 1
    static let character = 2
    static let URL = 3
}

class SearchRadicalsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var radicalCode: String?
    
    var radicalFCCodeList: NSDictionary! = nil
    
    var radicalWebsites: NSDictionary! = nil
    
    var possibleRadicals: NSArray?
    
    var userSelectedRadical: String?
    
    var selectedRadicalInfo: Array<String>?
    
    @IBOutlet weak var collectionView: UICollectionView?
    
    @IBOutlet weak var infoTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchRadical()
        //displayChoices()
    }
    /* @@HP: load dicts */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        radicalFCCodeList = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("radical FC code list", withExtension: "plist")!)
        radicalWebsites = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("radical websites", withExtension: "plist")!)
    }
    
    /* @@HP: use the corner FC code search in the radical dictionary, return the possible radical info as Array(s) */
    func searchRadical() {
        if let code = radicalCode {
            /* @@HP: check if the code is in the dict */
            if radicalFCCodeList[code] as? NSArray == nil {
                possibleRadicals = radicalFCCodeList["-----"] as? NSArray
                infoTextField.text = "Radical Not Found"
            }
            else {
                possibleRadicals = radicalFCCodeList[code] as? NSArray
            }
        }
        else {
            println("radical code \(radicalCode) is not in the diactionary")
        }
        
    }
    
    /* @@HP: prepare the possible results for collection view to display Debug Only*/
    func displayChoices() {
        if let choices = possibleRadicals {
            for item in choices {
                println("choices item passed in: \(item)")
            }
        }
        else {
            println("no radicals is selected")
        }
    }
    
    /* @@HP: use the select key to acquire website link, thios should happen in prepare for segue */
    func searchWebsite() -> String {
        if let choice = userSelectedRadical {
            selectedRadicalInfo = radicalWebsites[choice] as? Array<String>
            
            return selectedRadicalInfo![RadicalProperties.URL]
        }
        else {
            println("the user did not select radical of choice(s)")
            
            return PAGE_404_URL
        }
    }
    
    //////////////////// Collection View Initilizatino //////////////////////////////////////
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        if let count = possibleRadicals?.count {
            return count
        }
        else {
            println("the radical choice array is empty")
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Identifiers.reuseIdentifier, forIndexPath: indexPath) as! SearchCollectionViewCell
        
        // Configure the cell
        if let itemCharacter = possibleRadicals?.objectAtIndex(indexPath.row) as? String {
            cell.radicalInfo = radicalWebsites[itemCharacter] as? Array
        }
        else {
            println("radical website dict lookup results not found")
        }
        /* @@HP: this action I learned from Alex coule make a customized call back function to the target from subview */
        //cell.radicalChoiceButtonField.addTarget(self, action: "handleTapped:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var cell : SearchCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! SearchCollectionViewCell
        if cell.cellIsTapped == false {
            cell.cellIsTapped = true
            cell.backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.2, alpha: 0.5)
        }
        else {
            cell.cellIsTapped = false
            cell.backgroundColor = UIColor.clearColor()
        }
        /* @@HP: remind user of the number of selection, however, this should prevent user advance to the next view when more than one radical is selected, for now, I don't know how */
        if selectOnlyOneRadical() > 1 {
            infoTextField.text = "Please select only ONE item!"
        }
        else if selectOnlyOneRadical() == 1 {
            infoTextField.text = "Click on search for meanings!"
        }
        else {
            infoTextField.text = "Select the correct radical !"
        }
        
        /* @@HP: when user touch on a cell, select the cell's character key */
        if let radicalInfo = cell.radicalInfo {
            userSelectedRadical = radicalInfo[RadicalProperties.character]
        }
        else{
            println("radical info in cell \(indexPath.row) is empty")
        }
        
        
    }
    /* @@HP: check the cell status, there must be ONLY one select is selected at a single search ! */
    func selectOnlyOneRadical() -> Int{
        var selectItemNumber = 0
        for cell in self.collectionView!.visibleCells() as! [SearchCollectionViewCell] {
            if cell.cellIsTapped == true {
                ++selectItemNumber
            }
        }
        return selectItemNumber
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier ?? "MISSING" {
        case Identifiers.radicalMeaningsSegue:
            // figure out which row of the table we're transitioning from
            searchWebsite()
            // now need to look up the RadicalsViewController instance
            if let resultVC = segue.destinationViewController as? ResultsViewController {
                
                if let radicalInfo = selectedRadicalInfo {
                    resultVC.title = "~ \(radicalInfo[RadicalProperties.character]) ~"
                    resultVC.websiteURL = searchWebsite()
                }
                else{
                    println("selected radical info not found")
                }
            }
            else {
                assertionFailure("destination of segue was not a ResultsViewController!")
            }
            
        default:
            assertionFailure("unknown segue ID \(segue.identifier)")
        }
        
    }
    
    
}
