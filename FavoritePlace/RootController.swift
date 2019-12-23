import UIKit
import RealmSwift

class RootController: UITableViewController {
    
    var places : Results<Place>!
    var currentPlace : Place?
    
//    var places =  Place.make()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        places = StorageManager.realm.objects(Place.self)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.isEmpty ? 0 : places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell

        let place = places[indexPath.row]

        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace.clipsToBounds =  true

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let rmPlace = places[indexPath.row]
        
        let contextDelete = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            StorageManager.remove(rmPlace)

            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
         }
        
         let swipeActions = UISwipeActionsConfiguration(actions: [contextDelete])
        
        return swipeActions
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            guard let index = tableView.indexPathsForSelectedRows?[0].row else { return }
            
            guard let destNewPlace = segue.destination as? NewPlaceViewController else {
                return
            }
            
            destNewPlace.currentPlace = places[index]
            
            
        }
    }
    
    @IBAction func unwindSegue(_ segue : UIStoryboardSegue) {
        
        guard let newPlaceController = segue.source as? NewPlaceViewController else { return }
        
        newPlaceController.savePlace()
        
        tableView.reloadData()
        
    }
    
}
