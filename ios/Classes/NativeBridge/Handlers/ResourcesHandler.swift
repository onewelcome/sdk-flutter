import Foundation
import OneginiSDKiOS
import OneginiCrypto
import UIKit

typealias FetchResourcesProtocol = FetchDeviceListInteractorProtocol & AppDetailsInteractorProtocol & FetchImplicitDataInteractorProtocol
typealias FlutterDataCallback = (Any?, SdkError?) -> Void

class ResourcesHandler: FetchResourcesProtocol {
    var deviceListInteracator: FetchDeviceListInteractorProtocol
    var appDetailsInteracator: AppDetailsInteractorProtocol
    var fetchImplicitDataInteractor: FetchImplicitDataInteractorProtocol
    
    init(deviceListInteracator: FetchDeviceListInteractorProtocol? = nil, appDetailsInteracator: AppDetailsInteractorProtocol? = nil, fetchImplicitDataInteractor: FetchImplicitDataInteractorProtocol? = nil) {
        self.deviceListInteracator = deviceListInteracator ?? FetchDeviceListInteractor()
        self.appDetailsInteracator = appDetailsInteracator ?? AppDetailsInteractor()
        self.fetchImplicitDataInteractor = fetchImplicitDataInteractor ?? FetchImplicitDataInteractor()
    }
    
    func fetchDeviceList(completion: @escaping(Any?, SdkError?) -> Void) {
        self.deviceListInteracator.fetchDeviceList(completion: completion)
    }
    
    func fetchAppDetails(completion: @escaping (Any?, SdkError?) -> Void) {
        self.appDetailsInteracator.fetchAppDetails(completion: completion)
    }
    
    func fetchImplicitResources(profile: ONGUserProfile, completion: @escaping (Any?, SdkError?) -> Void) {
        self.fetchImplicitDataInteractor.fetchImplicitResources(profile: profile, completion: completion)
    }

}
