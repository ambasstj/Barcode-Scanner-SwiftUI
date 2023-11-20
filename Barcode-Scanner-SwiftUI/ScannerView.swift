//
//  ScannerView.swift
//  Barcode-Scanner-SwiftUI
//
//  Created by Tevin Jones on 11/20/23.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context){}
    
    final class Coordinator: NSObject, ScannerVCDelegate{
        
        func didFind(barcode: String) {
            print(barcode)
        }
        
        func didSurface(error: CameraError) {
            print(error.rawValue)
        }
    }
}

#Preview {
    ScannerView()
}
