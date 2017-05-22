import Foundation

/**
    Model for various stops on a bus route
 
 */

public struct StopModel {
	public var displayName : String
	public var id : Int
    public var location: (latitude: Double, longitude: Double)
    public var distance: Double
    
	init?() {
        self.displayName = ""
        self.id = 0
        location = (0, 0)
        distance = 0
    }
}
