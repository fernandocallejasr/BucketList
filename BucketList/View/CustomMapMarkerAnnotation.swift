//
//  CustomMapMarkerAnnotation.swift
//  BucketList
//
//  Created by Fernando Callejas on 11/09/24.
//

import SwiftUI

struct CustomMapMarkerAnnotation: View {
    var body: some View {
        Image(systemName: "star.circle")
            .resizable()
            .foregroundStyle(.red)
            .frame(width: 44, height: 44)
            .background(.white)
            .clipShape(.circle)
    }
}

#Preview {
    CustomMapMarkerAnnotation()
}
