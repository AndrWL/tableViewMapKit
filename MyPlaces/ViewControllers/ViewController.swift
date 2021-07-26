//
//  ViewController.swift
//  MyPlaces
//
//  Created by Andrey on 08.07.2021.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
  
   private  let searchController = UISearchController(searchResultsController: nil)
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    @IBOutlet weak var reverseSorting: UIBarButtonItem!
    
    
    var places: [Place] = []
    let storageManager = StorageManager()
   private var ascentingSorting = true
    var filteredPlaces: [Place] = []
    var searchBarEmpty: Bool  {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchController.isActive && !searchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup search results
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        places = storageManager.fetchData(places)
        tableView.reloadData()
    
       
    }
        
     
    
    
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        if let newPlaceVc = segue.source as? NewPlaceTableViewController {
           
            newPlaceVc.savePlace()
            guard let place =  newPlaceVc.placeNew   else { return  }
            places.append(place)
            tableView.reloadData()
        }
 
    }
    
    
    @IBAction func reverseSorting(_ sender: UIBarButtonItem) {
        ascentingSorting.toggle()
        if ascentingSorting == true {
            reverseSorting.image = #imageLiteral(resourceName: "AZ")
            
        } else {
            reverseSorting.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
        
    }
    
     
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        sorting()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
   func filter(sort: String, ascending: Bool? = nil) {
        do {
            let request = Place.fetchRequest() as NSFetchRequest<Place>
       
            let sort  = NSSortDescriptor(key: sort, ascending: ascentingSorting)
            request.sortDescriptors = [sort]
               self.places = try storageManager.managedContext.fetch(request)
            storageManager.saveContext()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    private func sorting() {
        if segmentedControll.selectedSegmentIndex == 0 {
            filter(sort: "name", ascending: ascentingSorting)
        } else {
            filter(sort: "location", ascending: ascentingSorting)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rename" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let placeFiltered = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
          
          
            
            let newVc = segue.destination as! NewPlaceTableViewController
            newVc.placeNew = placeFiltered
            
        
            
           
       
           
             
           
            
            }
        }
       
    }
    
    
   


    
 




