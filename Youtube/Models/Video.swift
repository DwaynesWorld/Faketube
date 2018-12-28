//
//  Video.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/24/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit

struct Video : Codable {
    
    var title: String?
    var thumbnailImageName: String?
    var numberOfViews: Int?
    var uploadDate: Date?
    
    var channel: Channel?
}
