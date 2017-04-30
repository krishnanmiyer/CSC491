import Foundation

public struct RouteModel {
	public var displayName : String
	public var id : Int

    /**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let items = Items(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Items Instance.
     */
    public init?(_ id:Int, _ name:String) {

		self.displayName = name
		self.id = id
	}
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let items = Items(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Items Instance.
     */
     public init?() {
        self.displayName = ""
        self.id = 0
    }
}
