//
//  HomeModel.swift
//  StoreApp
//
//  Created by Giri on 4/19/25.
//



struct Datalist: Codable {
    var id: Int?
    var title: String?
    var price: Double?
    var description: String?
    var category: String?
    var image: String?
    var rating: Rating?
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case price
        case description
        case category
        case image
        case rating
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.price = try container.decodeIfPresent(Double.self, forKey: .price)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.category = try container.decodeIfPresent(String.self, forKey: .category)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.rating = try container.decodeIfPresent(Rating.self, forKey: .rating)
    }
    
}

struct Rating: Codable {
    var rate: Double?
    var count: Int?
    enum CodingKeys: CodingKey {
        case rate
        case count
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rate = try container.decodeIfPresent(Double.self, forKey: .rate)
        self.count = try container.decodeIfPresent(Int.self, forKey: .count)
    }
}
