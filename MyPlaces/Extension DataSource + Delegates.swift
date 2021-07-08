//
//  Extension DataSource + Delegates.swift
//  MyPlaces
//
//  Created by Andrey on 08.07.2021.
//

import UIKit


extension ViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        restaurantNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
       
        let nameOfRestaurant = restaurantNames[indexPath.row]
       
        
        content.image = UIImage(named: nameOfRestaurant)
        content.text = nameOfRestaurant
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}
