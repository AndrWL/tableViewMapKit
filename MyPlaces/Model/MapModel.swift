//
//  MapModel.swift
//  MyPlaces
//
//  Created by Andrey on 17.07.2021.
//

import UIKit


class MapModel {
    
    var name: String?
    var location: String?
    var type: String?
    var imagePlace: UIImage?
    
    
    init?(mapModel: Place) {
        name = mapModel.name
        location = mapModel.location
        type = mapModel.type
        guard let image = UIImage(data: mapModel.imageData ?? Data()) else { return }
        imagePlace = image
    
    }

}
