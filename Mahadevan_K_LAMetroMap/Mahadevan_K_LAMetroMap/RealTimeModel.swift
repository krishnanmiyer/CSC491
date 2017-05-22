import Foundation

/**
 
 Model for realtime status of buses for a stop
 
 */
public struct RealTimeModel {
    public var blockId : Int
    public var runId : String
    public var seconds : Double
    public var isDeparting : Bool
    public var routeId : Int
    public var minutes : Double
       
    public init?() {
        self.blockId = 0
        self.runId = ""
        self.seconds = 0.0
        self.isDeparting = false
        self.routeId = 0
        self.minutes = 0.0
    }
    
    public func toString() -> String {
        if (seconds > 59) {
            return "Route: \(routeId): \(Int(minutes)) minute(s)"
        }
        else {
            return "Route: \(routeId): \(Int(seconds)) second(s)"
        }
    }
}
