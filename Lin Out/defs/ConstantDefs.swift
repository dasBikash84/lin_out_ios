//
//  ConstantDefs.swift
//  Lin Out
//
//  Created by bikash on 5/6/20.
//  Copyright © 2020 bikash. All rights reserved.
//

import Foundation

struct ConstantDefs{
    struct SegueNames {
        static let Launcer_TO_LOGIN = "goToLogin"
        static let Launcer_TO_SIGN_IN = "goToSignIn"
        static let Launcer_TO_SIGN_OUT = "goToSignOut"
        static let LOGIN_TO_SIGN_IN = "loginToSignIn"
        static let SIGN_IN_TO_SIGN_OUT = "signInToSignOut"
        static let SIGN_IN_TO_LAUNCHER = "signInToLauncher"
        static let SIGN_OUT_TO_LAUNCHER = "signOutToLauncher"
    }
    
    struct ErrorMessages {
        static let LOCATION_REQUIRD_MESSAGE = "Location permission is required for app operation!"
    }
}
