import Foundation

// MARK: - WeatherData
struct WeatherData: Codable {
    let message, cod: String
    let count: Int
    let list: [City]
}

// MARK: - List
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let main: MainClass
    let dt: Int
    let wind: Wind
    let sys: Sys
    let rain, snow: JSONNull?
    let clouds: Clouds
    let weather: [Weather]
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let country: Country
}

enum Country: String, Codable {
    case ru = "RU"
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: MainEnum
    let weatherDescription: Description
    let icon: Icon
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum Icon: String, Codable {
    case the03N = "03n"
}

enum MainEnum: String, Codable {
    case clouds = "Clouds"
}

enum Description: String, Codable {
    case scatteredClouds = "scattered clouds"
}

// MARK: - Wind
struct Wind: Codable {
    let speed, deg: Int
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
