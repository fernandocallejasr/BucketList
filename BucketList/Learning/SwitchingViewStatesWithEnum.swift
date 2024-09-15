//
//  SwitchingViewStatesWithEnum.swift
//  BucketList
//
//  Created by Fernando Callejas on 09/09/24.
//

import SwiftUI

struct SwitchingViewStatesWithEnum: View {
    @State private var loadingState = LoadingStatePractice.success
    
    var body: some View {
        if loadingState == .loading {
            LoadingView()
        } else if loadingState == .success {
            SuccessView()
        } else if loadingState == .failed {
            FailedView()
        }
    }
}

enum LoadingStatePractice {
    case loading
    case success
    case failed
}

struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("FAILED")
    }
}

#Preview {
    SwitchingViewStatesWithEnum()
}
