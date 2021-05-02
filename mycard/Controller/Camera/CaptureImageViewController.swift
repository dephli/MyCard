//
//  CaptureImageViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/20/20.
//

import UIKit
import AVFoundation
import CropViewController

class CaptureImageViewController: UIViewController {
    static let identifier = String(describing: self)
// MARK: - Outlets
    @IBOutlet weak var videoPreviewView: UIView!

// MARK: - Variables
    private var captureSession: AVCaptureSession?
    private var stillImageOutput: AVCapturePhotoOutput?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var capturedImage: UIImage?
    private let imagePicker = UIImagePickerController()

// MARK: - ViewController methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCamera()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ReviewPhotoViewController {
            let vc = segue.destination as? ReviewPhotoViewController
            vc?.backgroundImage = capturedImage
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

// MARK: - Custom Methods
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
        let cropViewController = CropViewController(image: image!)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
}

// MARK: - Photo Capture delegate
extension CaptureImageViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        guard let imageData = photo.fileDataRepresentation()
        else {return}

        let image = UIImage(data: imageData)
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

extension CaptureImageViewController: CropViewControllerDelegate {
    func cropViewController(
        _ cropViewController: CropViewController,
        didCropToImage image: UIImage,
        withRect cropRect: CGRect,
        angle: Int) {
        self.capturedImage = image
        cropViewController.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: K.Segues.capturePhotoToReviewPhoto, sender: self)
    }
}
