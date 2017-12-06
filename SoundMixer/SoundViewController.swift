//
//  SoundViewController.swift
//  SoundMixer
//
//  Created by Heather Cates on 12/5/17.
//  Copyright © 2017 Heather Cates. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var recButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setUpRecorder(){
        do{
            //create audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            try session.setActive(true)
            //create url for audio file
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents =  [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            //create setting for the audio recorder
            var settings : [String:AnyObject] = [:]
            settings [AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = 44100.0 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
            
            //create audio recorder object
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        }
        catch let error as NSError{print (error)}
    }
    
    @IBAction func recButtonTapped(_ sender: Any) {
        
        if (audioRecorder!.isRecording){
            //stop recording
            audioRecorder?.stop()
            //change button title to record
            recButton.setTitle("Record", for: .normal)
            //enable add and play buttons
            playButton.isEnabled = true
            addButton.isEnabled = true
            
        }
        else{
            //start recording
            audioRecorder?.record()
            //change button title to stop
            recButton.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        }
        catch{}
        
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        sound.audioName = nameTextField.text
        do{
        try sound.audio = Data(contentsOf: audioURL!)
        }
        catch{}
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        //pop to last view
        navigationController?.popViewController(animated: true)
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
