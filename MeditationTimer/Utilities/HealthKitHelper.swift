//
//  HealthKitHelper.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 30.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import Foundation
import HealthKit

protocol HealthKitHelperDelegate {
    func healthKitCheckComplete(authorizationStatus: HKAuthorizationStatus)
    func healthKitWriteComplete(status: Bool)
    func healthKitAuthorizeComplete(status: Bool)
}

class HealthKitHelper {
    
    static let shared = HealthKitHelper()
    static let healthQueue = DispatchQueue(label: "healthQueue", attributes: .concurrent)
    
    let mindfulSessionCategoryType: HKCategoryType?
    let healthStore: HKHealthStore?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            mindfulSessionCategoryType = HKObjectType.categoryType(forIdentifier: .mindfulSession)
        } else {
            healthStore = nil
            mindfulSessionCategoryType = nil
            print("WARNING: error in init for shared HealthKitHelper")
        }
    }
    
    func checkAuthorizationStatus(delegate: HealthKitHelperDelegate?) -> HKAuthorizationStatus {
        guard let mindfulSessionCategoryType = mindfulSessionCategoryType, let authorizationStatus = healthStore?.authorizationStatus(for: mindfulSessionCategoryType) else {
            print("WARNING: error with mindfulSessionCategoryType")
            delegate?.healthKitCheckComplete(authorizationStatus: HKAuthorizationStatus.notDetermined)
            return HKAuthorizationStatus.notDetermined
        }
        delegate?.healthKitCheckComplete(authorizationStatus: authorizationStatus)
        return authorizationStatus
    }
    
    func authorizeHealthKit(delegate: HealthKitHelperDelegate?) {
        guard let healthStore = healthStore, let mindfulSessionCategoryType = mindfulSessionCategoryType else {
            delegate?.healthKitAuthorizeComplete(status: false)
            return
        }
        
        let healthKitTypesToWrite: Set<HKSampleType> = [mindfulSessionCategoryType]
        let healthKitTypesToRead: Set<HKSampleType> = []
        
        // Request Authorization
        healthStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
            delegate?.healthKitAuthorizeComplete(status: self.checkAuthorizationStatus(delegate: nil) == HKAuthorizationStatus.sharingAuthorized)
        }
    }
    
    func writeMindfulnessData(delegate: HealthKitHelperDelegate?, session: MeditationSession) {
        guard let healthStore = healthStore, let sampleType = HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession), checkAuthorizationStatus(delegate: nil) == HKAuthorizationStatus.sharingAuthorized else {
            delegate?.healthKitWriteComplete(status: false)
            print("Health Kit write failed.")
            return
        }
        let sample = HKCategorySample(type: sampleType, value: HKCategoryValue.notApplicable.rawValue, start: session.date.addingTimeInterval(-session.duration), end: session.date)
        healthStore.save(sample, withCompletion: { (result, error) in
            delegate?.healthKitWriteComplete(status: result)
            if result {
                var session = session
                session.savedToHealth = true
                session.save()
            } else {
                print("Health Kit write failed.")
            }
        })
    }
}

