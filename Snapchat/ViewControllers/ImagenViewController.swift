//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by Rodrigo Ramos on 16/05/18.
//  Copyright © 2018 Ramos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
          let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func camaraTapped(_ sender: Any) {
      imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        elegirContactoBoton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imageData = UIImagePNGRepresentation(imageView.image!)!
        
        imagenesFolder.child("\(imagenID).jpg").putData(imageData, metadata: nil, completion:{(metadata, error) in
            print("Intentando subir una imagen")
            if error != nil{
                print("Ocurrio un error: \(String(describing: error))")
            }else{
                
                imagenesFolder.child("\(self.imagenID).jpg").downloadURL(completion: {(url,error) in
                    if error != nil{
                        print(error!)
                    }
                    if url != nil {
                        self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url!.absoluteString)
                    }
                })

            }
            
        })
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID
    }

}
