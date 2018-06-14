//
//  PopUpController.swift
//  Snapchat
//
//  Created by Rodrigo Ramos on 6/06/18.
//  Copyright © 2018 Ramos. All rights reserved.
//

import UIKit

protocol PopUpDelegado{
    func mostrarActividad(tipo:String)
}
class PopUpController: UIViewController {
    var delegado:PopUpDelegado?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func mostrarAc_Img(_ sender: Any) {
        delegado?.mostrarActividad(tipo: "imagen")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func mostrarAc_Audio(_ sender: Any) {
        delegado?.mostrarActividad(tipo: "audio")
        dismiss(animated: true, completion: nil)
    }
}
