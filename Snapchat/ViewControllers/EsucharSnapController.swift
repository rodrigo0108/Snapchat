//
//  EsucharSnapController.swift
//  Snapchat
//
//  Created by Rodrigo Ramos on 13/06/18.
//  Copyright © 2018 Ramos. All rights reserved.
//

import UIKit
import AVFoundation

class EsucharSnapController: UIViewController {
    
    var player : AVAudioPlayer!
    var snap = Snap()
    var fileUrl = URL(string: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        leerArchivo(snap:snap)
        }
    

    @IBAction func reproducirTapped(_ sender: Any) {

        do{
            player = try AVAudioPlayer(contentsOf: self.fileUrl!)
            player.prepareToPlay()
            player.play()
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        }
    
    
    
    func leerArchivo(snap:Snap) {

        let fileUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // create session by instantiating with configuration and delegate
        if NSURL(string: snap.audioURL) != nil
        {
            let url = URL(string: snap.audioURL)!
            let task = URLSession.shared.downloadTask(with: url, completionHandler: { (urldispositivo, response, error) in
                do{
                    self.fileUrl = fileUrls.first?.appendingPathComponent(snap.audioID)
                    
                    try FileManager.default.moveItem(at: urldispositivo!, to: self.fileUrl!)

                } catch let error{
                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }
}
