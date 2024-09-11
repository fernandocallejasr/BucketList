//
//  UsingTouchIDAndFaceID.swift
//  BucketList
//
//  Created by Fernando Callejas on 10/09/24.
//

import LocalAuthentication
import SwiftUI

struct UsingTouchIDAndFaceID: View {
    @State private var isUnlocked = false
    
    var body: some View {
        VStack {
            if isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                } else {
//                    print(error?.localizedDescription)
                }
            }
        } else {
            // no biometrics
//            print(error?.localizedDescription)
        }
    }
}

#Preview {
    UsingTouchIDAndFaceID()
}
