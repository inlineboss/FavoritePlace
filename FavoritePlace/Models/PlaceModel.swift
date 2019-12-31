import RealmSwift

class Place : Object {
    @objc dynamic var name : String = " "
    @objc dynamic var location : String?
    @objc dynamic var type : String?
    @objc dynamic var imageData : Data?
    @objc dynamic var date = Date ()
    @objc dynamic var rating = 0.0
    
    convenience init(_ name : String, _ location: String?, _ type: String?, _ image: Data?, _ rating: Double) {
        self.init()
        self.rating = rating
        self.name = name
        self.type = type
        self.location = location
        self.imageData = image
    }
}
