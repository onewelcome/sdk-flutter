//
//  UserProfileConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 24/04/2021.
//

import Foundation

import OneginiSDKiOS

protocol UserProfileConnectorProtocol: class {
    func setAuthenticatedUser(authenticatedUser: ONGUserProfile?)
    func getAuthenticatedUser() -> ONGUserProfile?
    func userProfiles(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func getUserProfiles() -> Array<ONGUserProfile>
    func getUserProfile(profileId: String?) -> ONGUserProfile?
}

class UserProfileConnector: UserProfileConnectorProtocol {
    
    var authenticatedUser: ONGUserProfile?
    
    func userProfiles(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        result(getUserProfiles())
    }
    
    func setAuthenticatedUser(authenticatedUser: ONGUserProfile?) {
        self.authenticatedUser = authenticatedUser
    }
    
    func getAuthenticatedUser() -> ONGUserProfile? {
        return authenticatedUser
    }
    
    func getUserProfiles() -> Array<ONGUserProfile> {
        
        // TODO: implement wrapper
        let profiles = Array(ONGUserClient.sharedInstance().userProfiles())
        return profiles
    }
    
    func getUserProfile(profileId: String?) -> ONGUserProfile? {
        let profiles = getUserProfiles()
        let profile = profiles.first(where: { $0.profileId == profileId})
        return profile
    }
    
}
