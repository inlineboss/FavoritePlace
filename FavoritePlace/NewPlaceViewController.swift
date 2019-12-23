//
//  NewPlaceViewController.swift
//  FavoritePlace
//
//  Created by inlineboss on 07.12.2019.
//  Copyright © 2019 inlineboss. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    var currentPlace : Place?
    
    var isImageChange : Bool = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        saveButton.isEnabled = false
        
        placeName.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        
        setupEditing()
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true)
        
    }
    private func setupNavigationBar() {
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil , action: nil)
        }
        
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        
        saveButton.isEnabled = true
    }
    private func setupEditing() {
         
        if currentPlace != nil {
            
            isImageChange = true
            
            placeName.text = currentPlace?.name
            
            placeLocation.text = currentPlace!.location
            
            placeType.text = currentPlace?.type
            
            guard let imageData = currentPlace?.imageData, let image = UIImage(data: imageData) else {
                return
            }
            
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            
            setupNavigationBar()
        }
    }
    
    func savePlace() {
        
        let pngImage : Data?
        
        if isImageChange {
            
             pngImage = placeImage.image?.pngData()
            
        } else {
            pngImage = #imageLiteral(resourceName: "imagePlaceholder").pngData()
        }

        let newPlace = Place(placeName.text!,
        placeLocation.text,
        placeType.text,
        pngImage)
        
        if currentPlace != nil {
            
            try! StorageManager.realm.write {
                
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
            }
                
        } else {
            StorageManager.save(newPlace)
        }
        
        
    }
    
    
}

extension NewPlaceViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true;
        
    }
    
    @objc func textFieldChange() {
        
        if placeName?.text?.isEmpty == false {
            
            saveButton.isEnabled = true
            
        } else {
            
            saveButton.isEnabled = true
            
        }
         
    }
    
}

extension NewPlaceViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            
            let actionScheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
                self.chooseImagePicker(.camera)
            }
            
            let photo = UIAlertAction(title: "Photo", style: .default) { (_) in
                self.chooseImagePicker(.photoLibrary)
            }
            
            let cancel = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
            
            actionScheet.addAction(camera)
            actionScheet.addAction(photo)
            actionScheet.addAction(cancel)
            
            present(actionScheet, animated: true)
            
        } else {
            
            view.endEditing(true)
            
        }
        
    }
}

extension NewPlaceViewController: UINavigationControllerDelegate {
    
    func chooseImagePicker (_ source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
             let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            imagePicker.delegate = self 
            
            present(imagePicker, animated: true)
            
        }
    }
}

extension NewPlaceViewController : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            
            return
            
        }
        
        placeImage.image = image
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        isImageChange = true
        
        dismiss(animated: true)
        
    }
    
}
