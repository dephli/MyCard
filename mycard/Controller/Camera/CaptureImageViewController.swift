//
//  CaptureImageViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/20/20.
//

import UIKit
import AVFoundation
import CoreMotion
import CropViewController

class CaptureImageViewController: UIViewController {
    static let identifier = String(describing: self)
// MARK: - Outlets
    @IBOutlet weak var videoPreviewView: UIView!
    @IBOutlet weak var scanAlertView: UIView!

// MARK: - Variables
    private var captureSession: AVCaptureSession?
    private var stillImageOutput: AVCapturePhotoOutput?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var capturedImage: UIImage?
    private let imagePicker = UIImagePickerController()
    var orientationLast = UIInterfaceOrientation(rawValue: 0)!
    var motionManager: CMMotionManager?
    var imageOrientation: UIImage.Orientation?

// MARK: - ViewController methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCamera()
        initializeMotionManager()
        let cameraViewed = UserDefaults.standard.bool(forKey: K.cameraViewedFirstTime)
        if !cameraViewed {
            Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(showCameraAlertView),
                userInfo: nil, repeats: false
            )
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        motionManager?.stopAccelerometerUpdates()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ReviewPhotoViewController {
            let vc = segue.destination as? ReviewPhotoViewController
            vc?.capturedImage = capturedImage
        }
    }

// MARK: - Actions
    @IBAction func capturePhotoPressed(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput?.capturePhoto(with: settings, delegate: self)
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func importCardButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func hideScanAlertButtonPressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: K.cameraViewedFirstTime)
        UIView.animate(withDuration: 0.2) {
            self.scanAlertView.alpha = 0
        } completion: { _ in
            self.scanAlertView.isHidden = true
        }
    }

// MARK: - Custom Methods
    @objc private func showCameraAlertView() {
        self.scanAlertView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.scanAlertView.alpha = 1
        }
    }

    private func initializeMotionManager() {
     motionManager = CMMotionManager()
     motionManager?.accelerometerUpdateInterval = 0.2
     motionManager?.gyroUpdateInterval = 0.2
     motionManager?.startAccelerometerUpdates(
        to: (OperationQueue.current)!,
        withHandler: { (accelerometerData, error) -> Void in
            if error == nil {
                self.outputAccelerationData((accelerometerData?.acceleration)!)
            } else {
                print("\(error!)")
            }
        })
     }

    private func outputAccelerationData(_ acceleration: CMAcceleration) {
        var orientationNew: UIInterfaceOrientation

        if acceleration.x >= 0.75 {
            orientationNew = .landscapeLeft
            imageOrientation = .down
            print("gyro landscape left")
        } else if acceleration.x <= -0.75 {
            orientationNew = .landscapeRight
            imageOrientation = .up
            print("gyro landscape right")
        } else if acceleration.y <= -0.75 {
            orientationNew = .portrait
            imageOrientation = .right
            print("gyro portrait")
        } else if acceleration.y >= 0.75 {
            orientationNew = .portraitUpsideDown
            imageOrientation = .left
            print("gyro upsinde")
        } else {
            return
        }
        if orientationNew == orientationLast {
            return
        }
        orientationLast = orientationNew
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = .high

        guard let backCamera = AVCaptureDevice.default(for: .video)
        else {
            self.alert(title: "Error", message: "Unable to access camera")
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
            self.alert(title: "Error", message: error.localizedDescription)
        }
    }

    private func setupLivePreview() {
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

    private func cropImage(_ image: UIImage?) {
        let fixedImage = image!.fixOrientation()
        self.capturedImage = fixedImage
        performSegue(withIdentifier: K.Segues.capturePhotoToReviewPhoto, sender: self)
    }
}

// MARK: - Photo Capture delegate
extension CaptureImageViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        guard let imageData = photo.fileDataRepresentation()
        else {return}
        var image = UIImage(data: imageData)
        let dataProvider  = CGDataProvider(data: imageData as CFData)
        let cgImageRef = CGImage(
            jpegDataProviderSource: dataProvider!,
            decode: nil, shouldInterpolate: true,
            intent: .defaultIntent
        )
        image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: imageOrientation ?? .up)
        cropImage(image)
    }
}

// MARK: - Imagepicker delegate
extension CaptureImageViewController: UIImagePickerControllerDelegate &
                                      UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Could not get original image")
        }
        imagePicker.dismiss(animated: true, completion: nil)
        cropImage(image)
    }
}
