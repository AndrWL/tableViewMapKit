//
//  cellPlaces.swift
//  MyPlaces
//
//  Created by Andrey on 08.07.2021.
//

import UIKit
import Cosmos

class CellPlaces: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
  
    @IBOutlet weak var cocmosImage: CosmosView!
    
    var arrayStars: [UIImageView] = []
    let starSize: CGSize = CGSize(width: 25, height: 15)
    
  func setupImage(starCount: Int) {
    
   
    
        for i in arrayStars {
         
            
            //viewImages.removeFromSuperview()
            i.removeFromSuperview()
        
        
        }
    
    
        
   
    arrayStars.removeAll()
    

    
    
    for _ in 0..<starCount {
        
        let image = UIImageView()
        image.image = UIImage(named: "highlightedStar")
        image.translatesAutoresizingMaskIntoConstraints = false
       
      
        arrayStars.append(image)

      
    }
  
    

 

    print(arrayStars.count)
  }
  

    
        
    }

