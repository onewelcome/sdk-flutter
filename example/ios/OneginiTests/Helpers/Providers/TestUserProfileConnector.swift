//
//  TestUserProfileConnector.swift
//  OneginiTests
//
//  Created by Patryk Gałach on 26/04/2021.
//

import OneginiSDKiOS
@testable import onegini

// TODO: implement
class TestUserProfileConnector: UserProfileConnectorProtocol {
    func setAuthenticatedUser(authenticatedUser: ONGUserProfile?) {
        
    }
    
    func getAuthenticatedUser() -> ONGUserProfile? {
        return nil
    }
    
    func userProfiles(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
    }
    
    func getUserProfiles() -> Array<ONGUserProfile> {
        return []
    }
    
    func getUserProfile(profileId: String?) -> ONGUserProfile? {
        return nil
    }
}
