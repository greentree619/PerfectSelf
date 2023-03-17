//
//  AvailableAudioInputsViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 2/28/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import AVFoundation

protocol AvailableAudioInputsViewControllerDelegate {
    func didFinishedAudioInput()
}

class AvailableAudioInputsViewController: UIViewController {

    @IBOutlet var tblAudioInpts: UITableView!
    var delegate: AvailableAudioInputsViewControllerDelegate?

    var audioInputs: [AVAudioSessionPortDescription] {
        AVAudioSession.sharedInstance().availableInputs ?? []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblAudioInpts.reloadData()
    }

    @IBAction func closeBtnClicked(_ sender: Any?) {
        delegate?.didFinishedAudioInput()
    }

}

extension AvailableAudioInputsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioInputs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AudioInputCell", for: indexPath) as? AudioInputCell else {
            fatalError("")
        }
        cell.configCell(name: audioInputs[indexPath.row].portName)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMicroPhone = audioInputs[indexPath.row]
        do {
            try AVAudioSession.sharedInstance().setPreferredInput(selectedMicroPhone)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch  {
            print("Error messing with audio session: \(error)")
        }
        self.delegate?.didFinishedAudioInput()
    }
}

class AudioInputCell: UITableViewCell {
    @IBOutlet var lblName: UILabel?

    func configCell(name: String) {
        lblName?.text = name
    }
}
