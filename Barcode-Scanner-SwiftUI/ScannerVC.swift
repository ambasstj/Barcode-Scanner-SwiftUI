//
//  ScannerVC.swift
//  Barcode-Scanner-SwiftUI
//
//  Created by Tevin Jones on 11/17/23.
//

import Foundation
import UIKit
import AVFoundation

enum CameraError: String {
    case invalidDeviceInput = "Invalid device for capturing image"
    case invalidScannedValue = "Improper value, must conform to ean8"
}

protocol ScannerVCDelegate: AnyObject {
    func didFind(barcode: String)
    func didSurface(error: CameraError)
}

final class ScannerVC: UIViewController{
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerVCDelegate?
    
    init(scannerDelegate: ScannerVCDelegate){
        super.init(nibName:nil, bundle:nil)
        self.scannerDelegate = scannerDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else  {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer.frame = view.layer.bounds
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    private func setupCaptureSession(){
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else{
            return
        }
        let videoInput: AVCaptureDeviceInput
        
        do{
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch{
            return
        }
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput){
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8,.ean13]
        } else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
    }
    
}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            return
        }
        
        guard let machineReadableOnject = object as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        guard let barcode = machineReadableOnject.stringValue else{
            return
        }
        scannerDelegate?.didFind(barcode: barcode)
    }
    
}
