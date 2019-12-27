import UIKit
import RealmSwift

class RootController: UIViewController {
    
   private var ascendingSorting = true
     
    private var places : Results<Place>!
    private var currentPlace : Place?
    private var filteredPlace : Results<Place>!
    private var searchController = UISearchController(searchResultsController: nil)
    
    private var isFiltring : Bool {
        get {
            return searchController.isActive && !searchBarIsEmpty
        }
    }
    
    private var searchBarIsEmpty : Bool {
        get {
            guard let text = searchController.searchBar.text else {
                return false
            }
            
            return text.isEmpty
        }
    }
  
    
    @IBOutlet var tableView : UITableView!
    
    @IBOutlet weak var reversedSortButton: UIBarButtonItem!
    
    @IBOutlet weak var segmentetController: UISegmentedControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        places = StorageManager.realm.objects(Place.self)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search:"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @IBAction func reverseSortAction(_ sender: UIBarButtonItem) {
        
        ascendingSorting.toggle()
        
        
        reversedSortButton.image = ascendingSorting ? #imageLiteral(resourceName: "AZ") : #imageLiteral(resourceName: "ZA")
        
        sortedData()
    }
    @IBAction func sortedList(_ sender: UISegmentedControl) {
        
        sortedData()
        
    }
    
    private func sortedData() {
        
        if segmentetController.selectedSegmentIndex == 0 {
        
            if isFiltring {
                
                filteredPlace = filteredPlace.sorted(byKeyPath: "date", ascending: ascendingSorting)
                
            } else {
                
                places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
                
            }
            
        } else if segmentetController.selectedSegmentIndex == 1 {
            
            if isFiltring {
                
                filteredPlace = filteredPlace.sorted(byKeyPath: "name", ascending: ascendingSorting)
                
            } else {
                
                places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
                
            }
            
            
        }
        
        tableView.reloadData()
    }
    
}

// MARK: UITableView
extension RootController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltring {
            return filteredPlace.count
        }
        
       return places.isEmpty ? 0 : places.count
    }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell

            let place = isFiltring ? filteredPlace[indexPath.row] : places[indexPath.row]
        
           cell.nameLabel.text = place.name
           cell.locationLabel.text = place.location
           cell.typeLabel.text = place.type
           cell.imageOfPlace.image = UIImage(data: place.imageData!)
           cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
           cell.imageOfPlace.clipsToBounds =  true
            cell.ratingView.rating = Int(place.rating)

           return cell
       }
       
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 85
       }
       
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           
           let rmPlace = places[indexPath.row]
           
           let contextDelete = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
               
               StorageManager.remove(rmPlace)

               tableView.deleteRows(at: [indexPath], with: .automatic)
               
            }
           
            let swipeActions = UISwipeActionsConfiguration(actions: [contextDelete])
           
           return swipeActions
       }
}

//MARK: Segue
extension RootController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            guard let index = tableView.indexPathsForSelectedRows?[0].row else { return }
            
            guard let destNewPlace = segue.destination as? NewPlaceViewController else {
                return
            }
            
            destNewPlace.currentPlace = isFiltring ? filteredPlace[index] : places[index]
            
            
        }
    }
    
    @IBAction func unwindSegue(_ segue : UIStoryboardSegue) {
        
        guard let newPlaceController = segue.source as? NewPlaceViewController else { return }
        
        newPlaceController.savePlace()
        
        tableView.reloadData()
        
    }
    
}

// MARK: Search text
extension RootController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterSearchText(searchController.searchBar.text!)
    }
    
    private func filterSearchText(_ text : String) {
        
        filteredPlace = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", text, text)
        
        tableView.reloadData()
    }
    
}


