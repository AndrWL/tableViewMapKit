

import UIKit
import CoreData


extension ViewController: UISearchResultsUpdating {

    public func updateSearchResults(for searchController: UISearchController) {
        filterContentToSearchText(searchController.searchBar.text!)
}


    private func filterContentToSearchText(_ searchText: String) {
        do {
            let request = Place.fetchRequest() as NSFetchRequest<Place>
       
            let pred  = NSPredicate(format: "name CONTAINS[c] %@ or location CONTAINS [c] %@", searchText, searchText)
            request.predicate = pred
               self.filteredPlaces = try storageManager.managedContext.fetch(request)
            storageManager.saveContext()
        } catch let error {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
}
