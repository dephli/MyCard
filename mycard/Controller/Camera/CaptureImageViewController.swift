//
//  CaptureImageViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/20/20.
//

import UIKit
import AVFoundation

class CaptureImageViewController: UIViewController {
    @IBOutlet weak var addManuallyButton: UIButton!
    @IBOutlet weak var importCardButton: UIButton!
    @IBOutlet weak var videoPreviewView: UIView!
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = .medium
        
        guard let backCamera = AVCaptureDevice.default(for: .video)
        else {
            print("unable to access camera")
            return
        }

        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession!.canAddInput(input) && captureSession!.canAddOutput(stillImageOutput!) {
                captureSession!.addInput(input)
                captureSession!.addOutput(stillImageOutput!)
                setupLivePreview()
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addManuallyButton.alignTextBelow()
        importCardButton.alignTextBelow()
        addManuallyButton.setTitle(with: K.TextStyles.captionWhite, for: .normal)
        importCardButton.setTitle(with: K.TextStyles.captionWhite, for: .normal)

        

        // Do any additional setup after loading the view.
    }
    
    
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.connection?.videoOrientation = .portrait
        videoPreviewView.layer.addSublayer(videoPreviewLayer!)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession!.startRunning()
            
            DispatchQueue.main.async {
                self.videoPreviewLayer?.frame = self.videoPreviewView.bounds
            }
        }
    }
    

    @IBAction func capturePhotoPressed(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CaptureImageViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
    }
}
