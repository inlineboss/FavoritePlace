import RealmSwift



class StorageManager {
    
    
    static var config : Realm.Configuration!
    
    static var realm : Realm!
    
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
