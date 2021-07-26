//
//  Extension DataSource + Delegates.swift
//  MyPlaces
//
//  Created by Andrey on 08.07.2021.
//

import UIKit


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering  {
           return filteredPlaces.count
       
           
        
        }
        return   places.count
    }
    
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellPlaces
        
       
        let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
        
     
       
        
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.cocmosImage.rating = place.rating
       
        
        
        
        if place.imageData == nil {
            cell.imagePlace.image = #imageLiteral(resourceName: "imagePlaceholder")
        } else {
            cell.imagePlace.image = UIImage(data: (place.imageData)!)
        }
       
        cell.imagePlace.layer.cornerRadius = cell.imagePlace.frame.height / 2
        cell.imageView?.clipsToBounds = true
        
      
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
  
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

 
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let place = places[indexPath.row]
       
        let delete = UIContextualAction(style: .destructive, title: "delete") { [self] _, _, _ in
            
            self.places.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            DispatchQueue.main.async {
                self.storageManager.managedContext.delete(place)
                self.storageManager.saveContext()
            }
        }
            
        
        
        delete.backgroundColor = .red
        delete.image = UIImage(systemName: "trash")
        let actionComfiguration = UISwipeActionsConfiguration(actions: [delete])
        
        actionComfiguration.performsFirstActionWithFullSwipe = false
        
        return actionComfiguration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
       
        
     
       
      
    }
  
    
    
 
}
