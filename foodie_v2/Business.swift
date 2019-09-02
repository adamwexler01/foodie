//
//  Restaurant.swift
//  foodie_v2
//
//  Created by Adam Wexler on 5/19/19.
//  Copyright © 2019 Adam Wexler. All rights reserved.
//

import Foundation
struct Business: Codable{
    
    var categories: [Categories]
    
    //location object
    var address1: String
    var address2: String
    var address3: String
    var city: String
    var zip_code: String
    var country: String
    var state: String
    var display_address: [String]
    
    //Coordinates object
    var latitude: Double
    var longitude: Double
    
    //One off variables
    var id: String
    var alias: String
    var name: String
    var image_url: String
    var is_closed: Bool
    var url: String
    var review_count: Int
    var rating: Double
    var price: String
    var phone: String
    var display_phone: String
    var distance: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case alias
        case name
        case image_url
        case is_closed
        case url
        case review_count
        case rating
        case price
        case phone
        case display_phone
        case distance
        case location
        case coordinates
        case categories
    }
    
    enum LocationKeys: String, CodingKey {
        case address1
        case address2
        case address3
        case city
        case zip_code
        case country
        case state
        case display_address
    }
    
    enum CoordinatesKeys: String, CodingKey {
        case latitude
        case longitude
    }
}

extension Business{
    init(from decoder: Decoder) throws {
        let business = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try business.decodeIfPresent(String.self, forKey: .id) ?? ""
        alias = try business.decodeIfPresent(String.self, forKey: .alias) ?? ""
        name = try business.decodeIfPresent(String.self, forKey: .name) ?? ""
        image_url = try business.decodeIfPresent(String.self, forKey: .image_url) ?? ""
        
        is_closed = try business.decodeIfPresent(Bool.self, forKey: .is_closed) ?? true
        url = try business.decodeIfPresent(String.self, forKey: .url) ?? ""
        review_count = try business.decodeIfPresent(Int.self, forKey: .review_count) ?? 0
        categories = try business.decodeIfPresent([Categories].self, forKey: .categories) ?? []
        rating = try business.decodeIfPresent(Double.self, forKey: .rating) ?? 0.0
        price = try business.decodeIfPresent(String.self, forKey: .price) ?? ""
        phone = try business.decodeIfPresent(String.self, forKey: .phone) ?? ""
        display_phone = try business.decodeIfPresent(String.self, forKey: .display_phone) ?? ""
        distance = try business.decodeIfPresent(Double.self, forKey: .distance) ?? 0.0
        
        let coordinates = try business.nestedContainer(keyedBy: CoordinatesKeys.self, forKey: .coordinates)
        latitude = try coordinates.decodeIfPresent(Double.self, forKey: .latitude) ?? 0.0
        longitude = try coordinates.decodeIfPresent(Double.self, forKey: .longitude) ?? 0.0
        
        let location = try business.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        address1 = try location.decodeIfPresent(String.self, forKey: .address1) ?? ""
        address2 = try location.decodeIfPresent(String.self, forKey: .address2) ?? ""
        address3 = try location.decodeIfPresent(String.self, forKey: .address3) ?? ""
        city = try location.decodeIfPresent(String.self, forKey: .city) ?? ""
        zip_code = try location.decodeIfPresent(String.self, forKey: .zip_code) ?? ""
        country = try location.decodeIfPresent(String.self, forKey: .country) ?? ""
        state = try location.decodeIfPresent(String.self, forKey: .state) ?? ""
        display_address = try location.decodeIfPresent([String].self, forKey: .display_address) ?? [""]
        
    }
}

extension Business{
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(alias, forKey: .alias)
        try container.encode(name, forKey: .name)
        try container.encode(image_url, forKey: .image_url)
        try container.encode(is_closed, forKey: .is_closed)
        
        try container.encode(url, forKey: .url)
        try container.encode(review_count, forKey: .review_count)
        try container.encode(categories, forKey: .categories)
        try container.encode(rating, forKey: .rating)
        try container.encode(price, forKey: .price)
        try container.encode(phone, forKey: .phone)
        try container.encode(display_phone, forKey: .display_phone)
        try container.encode(distance, forKey: .distance)
        
        var location = container.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        try location.encode(address1, forKey: .address1)
        try location.encode(address2, forKey: .address2)
        try location.encode(address3, forKey: .address3)
        try location.encode(city, forKey: .city)
        try location.encode(zip_code, forKey: .zip_code)
        try location.encode(country, forKey: .country)
        try location.encode(state, forKey: .state)
        try location.encode(display_address, forKey: .display_address)
        
        var coordinates = container.nestedContainer(keyedBy: CoordinatesKeys.self, forKey: .coordinates)
        try coordinates.encode(latitude, forKey: .latitude)
        try coordinates.encode(longitude, forKey: .longitude)
    }
}

struct Categories: Codable{
    var alias: String
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case alias
        case title
    }
}

extension Categories {
    init(from decoder: Decoder) throws {
        let categories = try decoder.container(keyedBy: CodingKeys.self)
        alias = try categories.decodeIfPresent(String.self, forKey: .alias) ?? ""
        title = try categories.decodeIfPresent(String.self, forKey: .title) ?? ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(alias, forKey: .alias)
        try container.encode(title, forKey: .title)
    }
}
