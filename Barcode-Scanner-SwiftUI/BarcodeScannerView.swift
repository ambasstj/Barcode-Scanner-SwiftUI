//
//  ContentView.swift
//  Barcode-Scanner-SwiftUI
//
//  Created by Tevin Jones on 11/17/23.
//

import SwiftUI

struct BarcodeScannerView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScannerView()
                    .frame(maxWidth: .infinity, maxHeight: 400)
                Spacer().frame(height:80)
                
                Label("Scanned Barcode", systemImage: "barcode.viewfinder")
                    .font(.title)
                Text("Not yet scanned")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.green)
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
        }
    
    }
}

#Preview {
    BarcodeScannerView()
}
