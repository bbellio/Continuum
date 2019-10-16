//
//  PhotoSelectorViewController.swift
//  Continuum
//
//  Created by Bethany Wride on 10/16/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import UIKit

// MARK: - Custom Protocol
protocol PhotoSelectorViewControllerDelegate: class {
    func photoSelectorViewControllSelected(image: UIImage)
}

// MARK: - Class Declaration
class PhotoSelectorViewController: UIViewController {
// MARK: - Properties and Global Variables
    weak var delegate: PhotoSelectorViewControllerDelegate?
    
// MARK: - Outlets
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        imageView.image = nil
        selectImageButton.setTitle("Select Image", for: .normal)
    }
    
// MARK: - Actions
    
    @IBAction func selectImageButtonTapped(_ sender: Any) {
        presentImagePickerActionSheet()
    }
} // Extension

// MARK: - Class Extensions

extension PhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePickerActionSheet() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let imageAlertController = UIAlertController(title: "Select a Photo", message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imageAlertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imageAlertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePickerController, animated: true)
            }))
        }
        imageAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(imageAlertController, animated: true)
    } // End of function
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectImageButton.setTitle("", for: .normal)
            imageView.image = photo
            delegate?.photoSelectorViewControllSelected(image: photo)
        }
    } // End of function
} // End of extension
