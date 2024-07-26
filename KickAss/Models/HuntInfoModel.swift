//
//  HuntInfoModel.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import Foundation

@Observable
class HuntInfoModel {
    var huntInfo = HuntInfo()
    var phoneList: [String]         = []
    
    init() {
        self.load()
    }
    struct HuntInfo: Codable {
        var huntTitle: String = ""
        var huntTheme: String = ""
        var huntStartDate: Date = Date.now
        var teamName: String = ""
        var carNumber: String = ""
        var teamMembers: [TeamMember] = [TeamMember(),TeamMember(),TeamMember(),TeamMember(),TeamMember(),TeamMember()]
    }
    struct TeamMember: Identifiable, Codable, Hashable {
        var id = UUID().uuidString
        var name: String = ""
        var phoneNumber: String = ""
        var iPhone: Bool = false
    }
    func updatePhoneList() {
        for member in 0..<huntInfo.teamMembers.count {
            if (huntInfo.teamMembers[member].phoneNumber != "") && (huntInfo.teamMembers[member].iPhone)  {
                phoneList.append(huntInfo.teamMembers[member].phoneNumber)
            }
        }
    }
    func load() {
        if FileManager().fileExists(atPath: huntInfoURL.path) {
            do {
                let jsonData = try Data(contentsOf: huntInfoURL)
                let data = try JSONDecoder().decode(HuntInfo.self, from: jsonData)
                huntInfo = data
                updatePhoneList()
            } catch {
                print(error)
            }
        }
    }
    func save() {
        do {
            let data = try JSONEncoder().encode(huntInfo)
            try data.write(to: huntInfoURL)
            updatePhoneList()
        } catch {
            print(error)
        }
    }
}
