//
//  Feed.swift
//  AntColony
//
//  Created by Adis Mulabdic on 11/01/2020.
//  Copyright © 2020 Adis Mulabdic. All rights reserved.
//

import Foundation

struct Feed: Decodable {
    var name: String?
    var postText: String?
    var uid: String?
    var time: Double?
    var numberOfLikes: Int?
    var isLiked: Bool?
}
