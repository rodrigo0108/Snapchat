//
//  AudioViewController.swift
//  Snapchat
//
//  Created by Rodrigo Ramos on 6/06/18.
//  Copyright © 2018 Ramos. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseStorage

class AudioViewController: UIViewController {
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioURL : URL?
    @IBOutlet weak var grabarButton: UIButton!
    @IBOutlet weak var infoButton: UILabel!
    @IBOutlet weak var elegirContactoButton: UIButton!
    
    var audioID = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        elegirContactoButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    func setupRecorder(){
        do{
            //creando una sesion de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //creando una direcciòn para el archivo de audio
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("*********************")
            print(audioURL!)
            print("*********************")
            
            //crear opciones para el grabador de audio
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            //Crear el objeto de grabacion de audio
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
            
        }catch let error as NSError{
            print(error)
        }
    }
    @IBAction func grabarTapped(_ sender: Any) {
        if audioRecorder!.isRecording{
            //Detener la grabación
            audioRecorder?.stop()
            //Cambiar el nombre del boton grabar
            grabarButton.setTitle("Grabar", for: .normal)
            grabarButton.isEnabled = true
            elegirContactoButton.isEnabled = true
            infoButton.text = "Grabación culminada"
        }else{
            // empezar a grabar
            audioRecorder?.record()
            // cambiar el titulo del boton a detener
            grabarButton.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        elegirContactoButton.isEnabled = false
        let audioFolder = Storage.storage().reference().child("audios")
        let audioData = NSData(contentsOf: audioURL!) as Data?
        
        audioFolder.child("\(audioID).m4a").putData(audioData!, metadata: nil, completion:{(metadata, error) in
            print("Intentando subir audio")
            if error != nil{
                print("Ocurrio un error: \(String(describing: error))")
            }else{
                
                audioFolder.child("\(self.audioID).m4a").downloadURL(completion: {(url,error) in
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
        siguienteVC.audioURL = sender as! String
        siguienteVC.audioID = audioID
    }
}
