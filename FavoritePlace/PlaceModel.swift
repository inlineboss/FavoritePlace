import RealmSwift

class Place : Object {
    @objc dynamic var name : String = " "
    @objc dynamic var location : String?
    @objc dynamic var type : String?
    @objc dynamic var imageData : Data?
    @objc dynamic var restoranImage : String? = nil
    
    convenience init(_ name : String, _ location: String?, _ type: String?, _ image: Data?) {
        self.init()
        
        self.name = name
        self.type = type
        self.location = location
        self.imageData = image
    }
}
