//
//  ITunes.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
//

import Foundation

struct ITunes: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String
    var artistName: String
    var previewUrl: String
    var artworkUrl60: String
    var artworkUrl100: String
}
