import Foundation

public struct StopModel {
	public var displayName : String
	public var id : Int
    public var location: (latitude: Double, longitude: Double)

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let items = Items(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Items Instance.
*/
	init?() {
        self.displayName = ""
        self.id = 0
        location = (0, 0)
    }
}
