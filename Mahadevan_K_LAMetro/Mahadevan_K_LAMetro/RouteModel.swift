import Foundation

/**
 Model for various metro routes
 
 */

public struct RouteModel {
	public var displayName : String
	public var id : Int

    public init?(_ id:Int, _ name:String) {

		self.displayName = name
		self.id = id
	}
    
     public init?() {
        self.displayName = ""
        self.id = 0
    }
}
