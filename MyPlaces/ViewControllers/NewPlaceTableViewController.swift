//
//  NewPlaceTableViewController.swift
//  MyPlaces
//
//  Created by Andrey on 08.07.2021.
//

import UIKit
import Cosmos
class NewPlaceTableViewController: UITableViewController {
    var placeNew: Place!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
   // @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var cosmosView: CosmosView!
   
    
    let storeManeger = StorageManager()
    
    var imageIsChanched = false
    var cuurentRating = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        
              saveBtn.isEnabled = false
              placeNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
              
        setupEditView()
     
        cosmosView.didTouchCosmos = { rating in
            self.cuurentRating = rating
            print(rating)
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
  
    }
    
    
   
    @IBAction func cancel(_ sender: UIBarButtonItem) {
     
        dismiss(animated: true)
       
    }
    
    
    private func setupEditView() {
        if  placeNew != nil  {
            setupNavigationBar()
            guard let data = placeNew?.imageData, let image = UIImage(data: data) else { return }
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeNameTextField.text = placeNew?.name
            placeType.text = placeNew?.type
            placeLocation.text = placeNew?.location
            cosmosView.rating = placeNew.rating
           
            
      }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        title = placeNew?.name
        saveBtn.isEnabled = true
        navigationItem.leftBarButtonItem = nil
    }
    //MARK: TableView Delegate
    
    override func tableView(_ tableView: UITableView,
                                         didSelectRowAt indexPath: IndexPath) {
       
        if indexPath.row == 0 {
            
            
            
           actionSheet()
        } else {
            view.endEditing(true)
        }
   }
   
    func actionSheet() {
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "camera", style: .default) { _ in
            self.imagepicker(source: .camera)
        }
       camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "gallery", style: .default) { _ in
            self.imagepicker(source: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        actionSheet.view.layoutIfNeeded()
        present(actionSheet, animated: true)
    }
    
    func savePlace() {
    
        
        if let placeNew = placeNew,  let name = placeNameTextField.text, let location = placeLocation.text, let type = placeType.text {
            placeNew.name = name
            placeNew.location = location
            placeNew.type = type
            placeNew.imageData  = placeImage.image?.pngData()
            placeNew.rating = cuurentRating
           
            storeManeger.saveContext()
        } else if placeNew == nil {
         
            placeNew = storeManeger.savePlace()
            placeNew.name = placeNameTextField.text
            placeNew.location = placeLocation.text
            placeNew.type = placeType.text
            placeNew.imageData = placeImage.image?.pngData()
           
            placeNew.rating = cuurentRating
            
            DispatchQueue.main.async {
                self.storeManeger.saveContext()
            }
         
        }
        
    }
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            let identifire = segue.identifier, let map = segue.destination as? MapViewController else { return }
        map.segueIdentifier = identifire
        guard let placenew = placeNew else {return}
        map.place = MapModel(mapModel: placenew)
        map.mapViewControllerDelegate = self
        if identifire == "getAddress" {
            print(segue.identifier)
            map.place?.name = placeNameTextField.text
            map.place?.location = placeLocation.text
            map.place?.type = placeType.text
            map.place?.imagePlace = placeImage.image
            
            
            }
           
            
            
        }


}

//MARK: TextField Delegate


extension NewPlaceTableViewController: UITextFieldDelegate {
    
    
    // Скрываем Клавиатуру по нажатию на done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    @objc private func textFieldChanged() {
        if placeNameTextField.text?.isEmpty == false {
            saveBtn.isEnabled = true
        } else {
            saveBtn.isEnabled = false
        }
    }

   
    
    
}
    //MARK: Work with image Picker
    
extension NewPlaceTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func imagepicker(source: UIImagePickerController.SourceType) {
            if UIImagePickerController.isSourceTypeAvailable(source) {
             let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = source
                present(imagePicker, animated: true)
            }
        }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        imageIsChanched = true
        dismiss(animated: true)
    }
    }

extension NewPlaceTableViewController: MapViewControllerDelegate {
    func getAddress(_ address: String) {
        placeLocation.text = address
    }
    
    
}

