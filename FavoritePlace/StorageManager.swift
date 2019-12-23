import RealmSwift



class StorageManager {
    
    static let realm = try! Realm(fileURL: URL(string:"file:///Users/inlineboss/Documents/FavoritePlace/default.realm")!)
    
    static func save (_ place : Place) {
        
        try! realm.write {
            
            realm.add(place)
            
        }
        
    }
    
    static func remove(_ place : Place ) {
        
        try! realm.write {
            
            realm.delete(place)
            
        }
    }
    
}
