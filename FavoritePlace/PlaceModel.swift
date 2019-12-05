import Foundation


struct Place {
    var name : String
    var location : String
    var type : String
    var image : String
    
    static var restoranArray = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]
    
    static func make() -> [Place] {
        
        var places = [Place]()
        
        for It in Place.restoranArray {
            places.append(Place(name: It, location: "Moscow", type: "Retoran", image: It))
        }
        
        return places
    }
}
