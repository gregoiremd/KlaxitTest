//
//  UserViewModel.swift
//  KlaxitTest
//
//  Created by Grégoire Marchand on 22/03/2022.
//

import Foundation

enum UserError: Error {
    case decode(Error)
    case reading
}

public class UserViewModel {
    
    private var user: User!
    
    let userName: Box<String> = Box("Chargement")
    let pictureUrl: Box<String> = Box("")
    let phoneNumber: Box<String?> = Box(nil)
    let company: Box<String?> = Box(nil)
    let profession: Box<String?> = Box(nil)
    let address: Box<String?> = Box(nil)
    
    init() {
        do {
            self.user = try loadUserInfos()
            initUserInfos(to: self.user)
        } catch let error {
            switch error {
            case UserError.decode:
                userName.value = "Decoding error"
            case UserError.reading:
                userName.value = "Read error"
            default:
                userName.value = "Default error"
            }
        }
    }
    
    func initUserInfos(to newUserInfos: User) {
        self.userName.value = "\(newUserInfos.firstName) \(newUserInfos.lastName)"
        self.pictureUrl.value = newUserInfos.pictureUrl
        self.phoneNumber.value = newUserInfos.phoneNumber
        self.company.value = newUserInfos.company
        self.profession.value = newUserInfos.profession
        self.address.value = newUserInfos.address
    }
    
    func setPhoneNumber(value: String) {
        self.phoneNumber.value = value
        self.user.phoneNumber = value
        persistUser()
    }
    
    func setCompany(value: String) {
        self.company.value = value
        self.user.company = value
        persistUser()
    }
    
    func setProfession(value: String) {
        self.profession.value = value
        self.user.profession = value
        persistUser()
    }
    
    func setAddress(value: String) {
        self.address.value = value
        self.user.address = value
        persistUser()
    }
    
    private func persistUser() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "user_infos")
        }
    }
    
    func loadUserInfos() throws -> User {
        let defaults = UserDefaults.standard
        if let storedUser = defaults.object(forKey: "user_infos") as? Data {
            let decoder = JSONDecoder()
            do {
                let jsonData = try decoder.decode(User.self, from: storedUser)
                return jsonData
            } catch let error {
                print("error:\(error)")
                throw UserError.decode(error)
            }
        } else if let url = Bundle.main.url(forResource: "account", withExtension: "json") {
            let decoder = JSONDecoder()
            do {
                let data = try Data(contentsOf: url)
                let jsonData = try decoder.decode(User.self, from: data)
                return jsonData
            } catch let error {
                print("error:\(error)")
                throw UserError.decode(error)
            }
        } else {
            //error no json to read
            throw UserError.reading
        }
    }
}
