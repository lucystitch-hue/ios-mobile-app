//
//  IMTQRCode.swift
//  IMT-iOS
//
//  Created by dev on 17/04/2023.
//

import AVFoundation
import UIKit

protocol IMTQRCodeProtocol {
    func start(_ parent: UIView)
    func stop()
    func permission(completion:@escaping(Bool) -> Void)
    var onScan: ((_ data: String) -> Void) { get set }
    var onNotAllowCamera: JVoid { get set }
}

class IMTQRCode: NSObject {
    var onScan: ((String) -> Void) = { _ in }
    var onNotAllowCamera: JVoid = { }
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer?
    var videoDevice: AVCaptureDevice?
    var timer: Timer?
    
    private func setup(parent: UIView, borderWidth: Int = 1, borderColor: CGColor = UIColor.yellow.cgColor ){
        captureSession = AVCaptureSession()
        
        if #available(iOS 13.0, *) {
            let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInUltraWideCamera], mediaType: .video, position: .back)
            if (discoverySession.devices.count == 0) {
                // no BuiltInTripleCamera
                videoDevice = AVCaptureDevice.default(for: AVMediaType.video);
            } else {
                videoDevice = discoverySession.devices.first;
            }
        } else {
            videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
        }
        
        guard let videoDevice = videoDevice else { return }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice) as AVCaptureDeviceInput
            captureSession.addInput(videoInput)
        } catch let error as NSError {
            print(error)
        }
        
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        previewLayer = getCameraLayer(parent: parent, session: captureSession)
        parent.layer.insertSublayer(previewLayer!, at: 0)
        self.rangeView(parent: parent, output: metadataOutput)
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
    
    private func stopCamera(){
        previewLayer?.removeFromSuperlayer()
        DispatchQueue.global().async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }
    
    private func getCameraLayer(parent: UIView, session: AVCaptureSession) -> AVCaptureVideoPreviewLayer{
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = parent.frame
        
        return previewLayer
    }
    
    private func rangeView(parent: UIView, frame:CGRect = CGRect(x: 0.2, y: 0.3, width: 0.6, height: 0.4), output: AVCaptureMetadataOutput){
        output.rectOfInterest = CGRect(x: frame.minY,y: 1-frame.minX-frame.size.width,width: frame.size.height, height: frame.size.width)
        
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.yellow.cgColor
        
        let previewWidth = parent.frame.size.width
        let previewHeight = parent.frame.size.height
        let size = min(previewWidth, previewHeight) / 3
        view.frame = CGRect(x: (previewWidth - size) / 2, y: (previewHeight - size) / 2, width: size, height: size)
        
        let topToBottom = UIView(frame: CGRect(x: (previewWidth - 3) / 2, y: (previewHeight - size ) / 2, width: 1, height: 10))
        topToBottom.backgroundColor = UIColor.yellow
        parent.addSubview(topToBottom)
        
        let leftToRight = UIView(frame: CGRect(x: (previewWidth - size) / 2, y: (previewHeight - 3) / 2, width: 10, height: 1))
        leftToRight.backgroundColor = UIColor.yellow
        parent.addSubview(leftToRight)
        
        let bottomToTop = UIView(frame: CGRect(x: (previewWidth - 3) / 2, y: (previewHeight + size - 20 ) / 2, width: 1, height: 10))
        bottomToTop.backgroundColor = UIColor.yellow
        parent.addSubview(bottomToTop)
        
        let rightToLeft = UIView(frame: CGRect(x: (previewWidth + size - 20 ) / 2, y: (previewHeight - 3) / 2, width: 10, height: 1))
        rightToLeft.backgroundColor = UIColor.yellow
        parent.addSubview(rightToLeft)
        
        parent.addSubview(view)
    }
    
    private func startTimerAutoFocus() {
        if #available(iOS 13.0, *) {
            if (videoDevice?.deviceType != .builtInUltraWideCamera) {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                    Utils.mainAsync { [weak self] in
                        self?.onAutoFocusCamera()
                    }
                })
            }
        }
    }
    
    private func endTimerAutoFocus() {
        if #available(iOS 13.0, *) {
            if (videoDevice?.deviceType != .builtInUltraWideCamera) {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }
    
    @objc private func onAutoFocusCamera() {
        do {
            try videoDevice?.lockForConfiguration()
            videoDevice?.focusMode = .autoFocus
            videoDevice?.unlockForConfiguration()
        } catch let error as NSError {
            print(error)
        }
    }
}

extension IMTQRCode: IMTQRCodeProtocol {
    func start(_ parent: UIView ) { //
        if(captureSession == nil) {
            setup(parent: parent)
        } else {
            previewLayer = getCameraLayer(parent: parent, session: captureSession)
            parent.layer.insertSublayer(previewLayer!, at: 0)
            
            DispatchQueue.global().async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
        
        startTimerAutoFocus()
    }
    
    func stop() {
        stopCamera()
        endTimerAutoFocus()
    }
    
    func permission(completion:@escaping(Bool) -> Void) {
        Utils.permissionCamera(completion: completion)
    }
}

extension IMTQRCode: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let strData = metadata.stringValue {
            self.onScan(strData)
        } else {
            self.onScan("")
        }
    }
}
