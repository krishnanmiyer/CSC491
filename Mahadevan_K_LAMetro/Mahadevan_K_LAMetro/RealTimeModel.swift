import Foundation

public struct RealTimeModel {
    public var blockId : Int
    public var runId : String
    public var seconds : Double
    public var isDeparting : Bool
    public var routeId : Int
    public var minutes : Double
    
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let items = Items(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Items Instance.
     */
    public init?() {
        self.blockId = 0
        self.runId = ""
        self.seconds = 0.0
        self.isDeparting = false
        self.routeId = 0
        self.minutes = 0.0
    }
}
