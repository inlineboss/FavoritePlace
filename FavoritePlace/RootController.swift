//
//  RootControllerTableViewController.swift
//  FavoritePlace
//
//  Created by inlineboss on 03.12.2019.
//  Copyright © 2019 inlineboss. All rights reserved.
//

import UIKit

class RootController: UITableViewController {

    var restoranArray = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restoranArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell

        cell.nameLabel.text = restoranArray[indexPath.row]
        cell.imageOfPlace.image = UIImage(named: restoranArray[indexPath.row])
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace.clipsToBounds =  true
        
        return cell 
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
}
