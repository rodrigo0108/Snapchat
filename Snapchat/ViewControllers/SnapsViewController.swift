//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Rodrigo Ramos on 16/05/18.
//  Copyright © 2018 Ramos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PopUpDelegado{
    
    func mostrarActividad(tipo: String) {
        if tipo=="imagen"{
            performSegue(withIdentifier: "mostrarAct_Imagen", sender: nil)
        }
        if tipo=="audio"{
            performSegue(withIdentifier: "mostrarAct_Audio", sender: nil)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var snaps : [Snap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
            Database.database().reference().child("usuarios").child(Auth.auth().currentUser!.uid).child("snaps").observe(DataEventType.childAdded, with: {(snapshot) in
                let snap = Snap()
                if let imagenURL =  (snapshot.value as! NSDictionary)["imagenURL"] as? String {
                    snap.imagenURL = imagenURL
                    snap.from = (snapshot.value as! NSDictionary)["from"] as! String
                    snap.descrip = (snapshot.value as! NSDictionary)["descripcion"] as! String
                    snap.id = snapshot.key
                    snap.imagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
                }else{
                    snap.from = (snapshot.value as! NSDictionary)["from"] as! String
                    snap.audioURL = (snapshot.value as! NSDictionary)["audioURL"] as! String
                    snap.audioID = (snapshot.value as! NSDictionary)["audioID"] as! String
                }
                self.snaps.append(snap)
                self.tableView.reloadData()
               
                
                
            })
        Database.database().reference().child("usuarios").child(Auth.auth().currentUser!.uid).child("snaps").observe(DataEventType.childMoved, with: {(snapshot) in
            var iterador = 0
            for snap in self.snaps{
                if snap.id == snapshot.key{
                    self.snaps.remove(at: iterador)
                }
                iterador += 1
            }
            self.tableView.reloadData()
            print(self.snaps)
            
        })
    }
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        try! Auth.auth().signOut()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        self.view.window?.rootViewController = storyBoard.instantiateInitialViewController()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0{
            return 1
        }
        else{
            return snaps.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaUsuario") as! CeldaUsuario
        
        if snaps.count == 0{
            cell.labelCorreo.text = "No tienes SNAPS 😶"
        }
        else{
            let snap = snaps[indexPath.row]
            cell.labelCorreo.text = snap.from

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        if snap.audioURL == "" {
            performSegue(withIdentifier: "versnapsegue", sender: snap)
        }else{
            performSegue(withIdentifier: "escucharsnapsegue", sender: snap)
        }
        }
    
    @IBAction func visualizarPopUp(_ sender: Any) {
        performSegue(withIdentifier: "mostrarPopUp", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapsegue" {
            let siguienteVC = segue.destination as! VerSnapViewController
            siguienteVC.snap = sender as! Snap
        }
        if segue.identifier == "escucharsnapsegue"{
            let siguienteVC = segue.destination as! EsucharSnapController
            siguienteVC.snap = sender as! Snap
        }
        if segue.identifier == "mostrarPopUp"{
            let siguienteVC = segue.destination as! PopUpController
            siguienteVC.delegado=self
        }
    }
    
}
