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
        var smsFowardingEnabled: Bool = false
    }
    struct TeamMember: Identifiable, Codable, Hashable {
        var id = UUID().uuidString
        var name: String = ""
        var phoneNumber: String = ""
        var iPhone: Bool = false
    }
    func phoneList() -> [String] {
        var phoneList: [String] = []
        for member in 0..<huntInfo.teamMembers.count {
            if (huntInfo.teamMembers[member].phoneNumber != "")  {
                if huntInfo.smsFowardingEnabled { //send to all team members
                    phoneList.append(huntInfo.teamMembers[member].phoneNumber)
                } else if huntInfo.teamMembers[member].iPhone { //send only to team member with iPhones
                    phoneList.append(huntInfo.teamMembers[member].phoneNumber)
                }
            }
        }
        return phoneList
    }
    func load() {
        if FileManager().fileExists(atPath: HUNT_INFO_URL.path) {
            do {
                let jsonData = try Data(contentsOf: HUNT_INFO_URL)
                let data = try JSONDecoder().decode(HuntInfo.self, from: jsonData)
                huntInfo = data
            } catch {
                print(error)
            }
        }
    }
    func save() {
        do {
            let data = try JSONEncoder().encode(huntInfo)
            try data.write(to: HUNT_INFO_URL)
        } catch {
            print(error)
        }
    }
}
