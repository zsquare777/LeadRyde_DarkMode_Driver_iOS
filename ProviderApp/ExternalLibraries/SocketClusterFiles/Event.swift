//import HandyJSON
//
//class EmitEvent: HandyJSON {
//    
//    var event: String!
//    var data: AnyObject?
//    var cid: Int!
//    
//    required init() {
//    }
//    
//    init(event: String, data: AnyObject?, cid : Int) {
//        self.event = event
//        self.data = data
//        self.cid = cid
//    }
//    
//}
//
//class ReceiveEvent : HandyJSON {
//    var data : AnyObject?
//    var error : AnyObject?
//    var rid : Int!
//    
//    convenience init(data : AnyObject? , error : AnyObject?, rid : Int) {
//        self.init()
//        self.data = data
//        self.error = error
//        self.rid = rid
//    }
//    
//    required init() {
//    }
//}
//
//class Channel : HandyJSON{
//    var channel : String!
//    var data : AnyObject?
//    
//    init(channel : String, data : AnyObject?) {
//        self.channel = channel
//        self.data = data
//    }
//    
//    required init() {
//    }
//}
//
//class AuthChannel : HandyJSON{
//    var channel : String!
//    var data : ChannelData?
//    
//    init(channel : String, token: String?) {
//        self.channel = channel
//        self.data = ChannelData(jwt: token)
//    }
//    
//    required init() {
//    }
//}
//
//class ChannelData: HandyJSON {
//    var jwt: String?
//    
//    init(jwt: String?) {
//        self.jwt = jwt
//    }
//    
//    required init() {
//    }
//}
//
//class AuthData : HandyJSON{
//    var authToken : String?
//    
//    
//    init(authToken : String?) {
//        self.authToken = authToken
//    }
//    
//    required init() {
//    }
//}
//
//class HandShake  : HandyJSON {
//
//    
//    var event : String!
//    var data  : AuthData!
//    var cid   : Int!
//
//    
//    init(event : String, data : AuthData, cid : Int) {
//        self.event = event
//        self.data = data
//        self.cid = cid
//    }
//    
//    required init() {
//    }
//    
//}
//
//class Model  {
//    
//    public static func getEmitEventObject(eventName: String, data : AnyObject?, messageId : Int) -> EmitEvent{
//        return EmitEvent(event: eventName, data: data, cid: messageId)
//    }
//    
//    public static func getReceiveEventObject(data : AnyObject?, error : AnyObject?, messageId : Int) -> ReceiveEvent{
//        return ReceiveEvent(data: data, error: error, rid: messageId)
//    }
//    
//    public static func getChannelObject (data : AnyObject?) -> Channel? {
//        if let channel = data as? [String : Any] {
//            return Channel(channel: channel["channel"] as! String, data: channel["data"] as AnyObject)
//        }
//        return nil
//    }
//    
//    public static func getSubscribeEventObject(channelName : String, messageId : Int) -> EmitEvent{
//        return EmitEvent(event: "#subscribe", data: Channel(channel: channelName, data :nil) as AnyObject, cid: messageId)
//    }
//    
//    public static func getSubscribeEventObject(channelName : String, messageId : Int, token: String? = nil) -> EmitEvent{
//        return EmitEvent(event: "#subscribe", data: AuthChannel(channel: channelName, token: token) as AnyObject, cid: messageId)
//    }
//    
//    public static func getUnsubscribeEventObject(channelName : String, messageId : Int) -> EmitEvent{
//        return EmitEvent(event: "#unsubscribe", data: channelName as AnyObject, cid: messageId)
//    }
//    
//    public static func getPublishEventObject(channelName : String, data : AnyObject?, messageId : Int) -> EmitEvent{
//        return EmitEvent(event: "#publish", data: Channel(channel: channelName, data :data) as AnyObject, cid: messageId)
//    }
//    
//    public static func getHandshakeObject(authToken : String?, messageId : Int) -> HandShake{
//        return HandShake(event: "#handshake", data: AuthData(authToken: authToken), cid: messageId)
//    }
//   
//}
//suleman

import Foundation

struct EmitEvent: Codable {
    var event: String
    var data: CodableValue?
    var cid: Int
}

struct ReceiveEvent: Codable {
    var data: CodableValue?
    var error: CodableValue?
    var rid: Int
}

struct Channel: Codable {
    var channel: String
    var data: CodableValue?
}

struct AuthChannel: Codable {
    var channel: String
    var data: ChannelData?
}

struct ChannelData: Codable {
    var jwt: String?
}

struct AuthData: Codable {
    var authToken: String?
}

struct HandShake: Codable {
    var event: String
    var data: AuthData
    var cid: Int
}

/// Codable wrapper for Any type
struct CodableValue: Codable {
    var value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let dict = try? container.decode([String: CodableValue].self) {
            value = dict
        } else if let array = try? container.decode([CodableValue].self) {
            value = array
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported type")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let bool as Bool:
            try container.encode(bool)
        case let string as String:
            try container.encode(string)
        case let dict as [String: CodableValue]:
            try container.encode(dict)
        case let array as [CodableValue]:
            try container.encode(array)
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Unsupported type"))
        }
    }
}

class Model {
    
    static func getEmitEventObject(eventName: String, data: Any?, messageId: Int) -> EmitEvent {
        return EmitEvent(event: eventName, data: data.map(CodableValue.init), cid: messageId)
    }
    
    static func getReceiveEventObject(data: Any?, error: Any?, messageId: Int) -> ReceiveEvent {
        return ReceiveEvent(data: data.map(CodableValue.init), error: error.map(CodableValue.init), rid: messageId)
    }
    
    static func getChannelObject(data: Any?) -> Channel? {
        guard let channelDict = data as? [String: Any],
              let name = channelDict["channel"] as? String,
              let dataVal = channelDict["data"] else { return nil }
        
        return Channel(channel: name, data: CodableValue(dataVal))
    }
    
    static func getSubscribeEventObject(channelName: String, messageId: Int) -> EmitEvent {
        let channel = Channel(channel: channelName, data: nil)
        return EmitEvent(event: "#subscribe", data: CodableValue(channel), cid: messageId)
    }
    
    static func getSubscribeEventObject(channelName: String, messageId: Int, token: String? = nil) -> EmitEvent {
        let authChannel = AuthChannel(channel: channelName, data: ChannelData(jwt: token))
        return EmitEvent(event: "#subscribe", data: CodableValue(authChannel), cid: messageId)
    }
    
    static func getUnsubscribeEventObject(channelName: String, messageId: Int) -> EmitEvent {
        return EmitEvent(event: "#unsubscribe", data: CodableValue(channelName), cid: messageId)
    }
    
    static func getPublishEventObject(channelName: String, data: Any?, messageId: Int) -> EmitEvent {
        let channel = Channel(channel: channelName, data: data.map(CodableValue.init))
        return EmitEvent(event: "#publish", data: CodableValue(channel), cid: messageId)
    }
    
    static func getHandshakeObject(authToken: String?, messageId: Int) -> HandShake {
        return HandShake(event: "#handshake", data: AuthData(authToken: authToken), cid: messageId)
    }
}
