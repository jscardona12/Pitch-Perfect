//
//  RecordSoundsViewController.swift
//  Pitch-Perfect
//
//  Created by Juan Cardona on 10/27/16.
//  Copyright © 2016 Juan Cardona. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate{
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear code")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        print("Record Button Press")
        recordingButton.isEnabled = false
        stopRecordingButton.isEnabled=true
        recordingLabel.text = "Recording in progress"
     
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }

   
    @IBAction func stopRecording(_ sender: AnyObject) {
        print("Stop recording press")
        recordingButton.isEnabled=true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = " Tap to Record"
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        audioRecorder.stop()

    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Audio has been recorded")
        if(flag){
            self.performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Recording have failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let playSoundsVC = segue.destination as! PlaySoundViewController
        let recordedAudioURL = sender as! NSURL
        playSoundsVC.recordedAudioURL = recordedAudioURL
        
    }
}

