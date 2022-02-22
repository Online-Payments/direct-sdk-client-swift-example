//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 04/08/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

import UIKit
import OnlinePaymentsKit

public class AppConstants {
    static let sdkBundle = Bundle(path: SDKConstants.kSDKBundlePath!)!
    public static var appBundle = Bundle.main
    static let kAppLocalizable = "AppLocalizable"
    public static var kPrimaryColor = UIColor(red: 0, green: 0.8, blue: 0, alpha: 1)
    public static var kDestructiveColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
    static let kClientSessionId = "kClientSessionId"
    static let kCustomerId = "kCustomerId"
    static let kMerchantId = "kMerchantId"
    static let kApplicationIdentifier = "Swift Example Application/v2.0.0"
    static let kBaseURL = "kBaseURL"
    static let kAssetsBaseURL = "kAssetsBaseURL"
    static let kPrice = "kPrice"
    static let kCurrency = "kCurrency"
    static let kCountryCode = "kCountryCode"
}
