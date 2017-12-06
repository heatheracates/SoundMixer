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
    
    var audioRecorder : AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRecorder()
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
            let audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            print("*****************")
            print(audioURL)
            print("*****************")
            //create setting for the audio recorder
            var settings : [String:AnyObject] = [:]
            settings [AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = 44100.0 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
            
        //create audio recorder object
        audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
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
        }
        else{
            //start recording
            audioRecorder?.record()
            //change button title to stop
            recButton.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
