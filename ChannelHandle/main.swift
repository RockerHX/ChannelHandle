//
//  main.swift
//  ChannelHandle
//
//  Created by RockerHX on 2018/5/24.
//  Copyright © 2018年 RockerHX. All rights reserved.
//


import Foundation


let DefaultFileName = "Channels.json"
let WriteFileName = "Channels.plist"


struct Channel: Codable {

    enum State: String, Codable {
        case normal = "NORMAL"
        case hidden = "HIDDEN"
        case stop   = "STOP"
        case delete = "DELETE"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case state = "status"
        case type
    }

    let id: Int
    let name: String
    let state: State
    var type: String?
}


struct Channels: Codable {
    var channels: [Channel]
}


func storeChannels(with channels: Channels) {
    do {
        let data = try JSONEncoder().encode(channels)
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let dictionary = json as? NSDictionary else { return }
        let fileName = WriteFileName
        let url = URL(fileURLWithPath: fileName)
        try dictionary.write(to: url)
    } catch {
        print("❌ Store something error:\n")
        print(error)
    }
}


func parse(with url: URL) -> Channels? {
    guard let data = try? Data(contentsOf: url) else {
        print("❌ Data Load failure, please check your json file name.")
        return nil
    }
    print("Input channel TYPE name:")
    guard let type = readLine()?.uppercased() else { return nil }

    do {
        var channels = try JSONDecoder().decode(Channels.self, from: data)
        channels.channels = channels.channels.map { (chanel) -> Channel in
            var newChannel = chanel
            newChannel.type = type
            return newChannel
        }
        return channels
    } catch {
        print("❌ JSON parse failure: \(error)")
    }
    return nil
}


func start() {
    print("Input your channels json file name（Default is \(DefaultFileName)）:")
    if var inputPath = readLine() {
        if inputPath.isEmpty {
            inputPath = DefaultFileName
        }
        let url = URL(fileURLWithPath: inputPath)
        guard let channels = parse(with: url) else { return }
        storeChannels(with: channels)
    } else {
        print("❌ File Load failure, please check your json file name.")
    }
}


start()

