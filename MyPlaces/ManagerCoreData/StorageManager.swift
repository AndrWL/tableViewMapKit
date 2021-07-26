//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Andrey on 09.07.2021.
//

import CoreData
import UIKit


struct StorageManager {
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func saveContext() {
        do {
            try managedContext.save()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchData(_ places: [Place]) -> [Place] {
        
        var placesList = places
        
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
       
        do {
            placesList = try managedContext.fetch(fetchRequest)
      
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return placesList
        
    }
    
   
    

    
    
    func savePlace() -> Place? {
        
        //Entity
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Place", in: managedContext) else { return  nil}
        guard let place = NSManagedObject(entity: entityDescription, insertInto: managedContext) as? Place else { return nil }
        
        return place
    }
    


}

