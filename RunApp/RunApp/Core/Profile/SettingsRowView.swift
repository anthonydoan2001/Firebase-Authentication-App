//
//  SettingsRowView.swift
//  RunApp
//
//  Created by user265613 on 10/21/24.
//


import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName) // SF Symbol for the setting icon
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title) // Title for the setting
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
    }
}
