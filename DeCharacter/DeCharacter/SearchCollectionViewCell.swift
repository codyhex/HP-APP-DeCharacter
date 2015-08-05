//
//  SearchCollectionViewCell.swift
//  HanZiBreaker
//
//  Created by Peng on 8/3/15.
//  Copyright (c) 2015 HePeng. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    /* @@HP: callIsTapped is used for the cell view hightlighted feature */
    var cellIsTapped = false
    
    @IBOutlet weak var radicalImage: UIImageView!
    
    @IBOutlet weak var radicalField: UILabel!
    
    var radicalInfo: Array<String>? {
        didSet {
            /* @@HP: Use the wiki radical ID "Radical 30" for example to name the radical image name with dim 100 * 100 pix */
            let imageName = radicalInfo![RadicalProperties.WikiID]
            
            if UIImage(named: imageName) == nil {
                println("The radical \(radicalInfo![RadicalProperties.character]) is not found in the bundle")
                radicalImage.image = UIImage(named: "RadicalImageNotFound")
            }
            else{
                radicalImage.image = UIImage(named: imageName)
            }
            /* @@HP: use the chinese radical character as the label */
            if radicalInfo![RadicalProperties.character] == "囧" {
                radicalField.text = ("Oops!")
            }
            else {
                radicalField.text = ("Item: " + radicalInfo![RadicalProperties.character])
            }
        }
    }
}
