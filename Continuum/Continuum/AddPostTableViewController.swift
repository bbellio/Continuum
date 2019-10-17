//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Bethany Wride on 10/15/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
// MARK: - Properties
    var selectedImage: UIImage?
    
// MARK: - Outlets
    @IBOutlet weak var captionTextField: UITextField!
    
    
// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        captionTextField.text = ""
    }

// MARK: - Actions
    @IBAction func addPostButtonTapped(_ sender: Any) {
        guard let photo = selectedImage,
            let text = captionTextField.text
            else { return }
        PostController.sharedInstance.createPostWith(image: photo, caption: text) { (post) in
            if post != nil {
                DispatchQueue.main.async {
                    // Moves selected tab image
                    self.tabBarController?.selectedIndex = 0
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toImageContainerVC" {
            let photoSelector = segue.destination as? PhotoSelectorViewController
            photoSelector?.delegate = self
        }
    }
} // End of class

// MARK: - Extension
extension AddPostTableViewController: PhotoSelectorViewControllerDelegate {
    func photoSelectorViewControllSelected(image: UIImage) {
        selectedImage = image
    }
}
