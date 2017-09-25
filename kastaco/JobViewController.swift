//
//  JobViewController.swift
//  kastaco
//
//  Created by Miguel Abreu on 9/22/17.
//  Copyright © 2017 Miguel Abreu. All rights reserved.
//

import UIKit
import AVFoundation

class JobViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recordButton: UIButton!
    var voiceNotes = NSArray()
    var recordingSession: AVAudioSession!
    var audioPlayer:AVAudioPlayer!
    var audios = [AVAudioRecorder]()
    var recording = false
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
            }
        } catch {
            // failed to record!
        }
        // Do any additional setup after loading the view.
    }
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(String(counter) +  ".m4a")
            counter = counter + 1
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            let av = try AVAudioRecorder(url: audioFilename, settings: settings)
            av.delegate = self
            av.record()
            audios.append(av)
            recording = true
            recordButton.setTitle("Stop", for: .normal)

        } catch {
        }
    }
    
    func finishRecording(success: Bool) {
        audios.last!.stop()
        recordButton.setTitle("Record", for: .normal)
        self.tableView.reloadData()
        recording = false
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        if !recording {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func finishRecording(success: Bool, audioRecorder:AVAudioRecorder) {
        if success{
            audioRecorder.stop()
            audios.append(audioRecorder)
            self.tableView.reloadData()
        }
        recording = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension JobViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = String(indexPath.row)
        if indexPath == tableView.indexPathForSelectedRow
        {
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audios[indexPath.row].url)
            audioPlayer.play()
        }
        catch{
            
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none

    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            audios.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

extension JobViewController: AVAudioRecorderDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            recording = false
            recorder.stop()
            self.tableView.reloadData()
        }
    }
    

}
