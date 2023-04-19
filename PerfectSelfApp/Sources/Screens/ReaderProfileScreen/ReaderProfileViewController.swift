//
//  ReaderProfileViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ReaderProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    var isEditingMode = false
    var id = ""
    var hourlyRate: Int = 0
    @IBOutlet weak var btn_edit_avatar: UIButton!
    @IBOutlet weak var btn_edit_userinfo: UIButton!
    @IBOutlet weak var btn_edit_experience: UIButton!
    @IBOutlet weak var btn_edit_about: UIButton!
    @IBOutlet weak var btn_edit_skills: UIButton!
    @IBOutlet weak var btn_edit_availability: UIButton!
    @IBOutlet weak var view_edit_hourly_rate: UIStackView!
    
    @IBOutlet weak var view_review: UIStackView!
    @IBOutlet weak var view_videointro: UIStackView!
    @IBOutlet weak var view_overview: UIStackView!
    @IBOutlet weak var view_container: UIView!
    
    @IBOutlet weak var btn_overview: UIButton!
    @IBOutlet weak var btn_videointro: UIButton!
    @IBOutlet weak var btn_review: UIButton!
    
    @IBOutlet weak var line_overview: UIImageView!
    @IBOutlet weak var line_videointro: UIImageView!
    @IBOutlet weak var line_review: UIImageView!
    
    @IBOutlet weak var readerAvatar: UIImageView!
    @IBOutlet weak var readerUsername: UILabel!
    @IBOutlet weak var readerTitle: UILabel!
    @IBOutlet weak var readerAbout: UITextView!
    @IBOutlet weak var readerSkills: UILabel!
    @IBOutlet weak var hourlyPrice: UILabel!
    @IBOutlet weak var timeslotList: UICollectionView!
    var items = [Availability]()
    let cellsPerRow = 1
    var videoUrl: URL!
    
    @IBOutlet var btnPlayPause: UIButton!
    @IBOutlet var slider: UISlider!

    var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                btnPlayPause.setImage(UIImage(named: "pause"), for: .normal)
            } else {
                btnPlayPause.setImage(UIImage(named: "play"), for: .normal)
            }
        }
    }

    @IBOutlet var playerView: PlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TimeSlotCollectionViewCell", bundle: nil)
        timeslotList.register(nib, forCellWithReuseIdentifier: "Time Slot Collection View Cell")
        timeslotList.dataSource = self
        timeslotList.delegate = self
        timeslotList.allowsSelection = true
        // Do any additional setup after loading the view.
        line_videointro.isHidden = true
        line_review.isHidden = true
        self.view_videointro.alpha = 0
        self.view_review.alpha = 0
        self.view_overview.frame.origin.x = 0
        self.view_videointro.frame.origin.x = self.view_container.frame.width
        self.view_review.frame.origin.x = self.view_container.frame.width
        
        btn_edit_avatar.isHidden = true;
        btn_edit_userinfo.isHidden = true;
        btn_edit_experience.isHidden = true;
        btn_edit_about.isHidden = true;
        btn_edit_skills.isHidden = true;
        btn_edit_availability.isHidden = true;
        view_edit_hourly_rate.isHidden = true;
        if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
            // Use the saved data
            id = userInfo["uid"] as! String
        } else {
            // No data was saved
            print("No data was saved.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        
        setupPlayer()
        // call API for reader profile
        
        showIndicator(sender: nil, viewController: self)
        
        webAPI.getReaderById(id:self.id) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                DispatchQueue.main.async {
                    hideIndicator(sender: nil);
                }
                return
            }
            do {
                let item = try JSONDecoder().decode(ReaderProfileDetail.self, from: data)
                print(item)
                DispatchQueue.main.async {
                    self.readerUsername.text = item.userName
                    self.readerTitle.text = item.title
                    self.readerAbout.text = item.about
                    self.hourlyPrice.text = "$\(item.hourlyPrice/4) / 15 mins"
                    self.readerSkills.text = item.skills
                    self.hourlyRate = item.hourlyPrice
                    if !item.avatarBucketName.isEmpty {
                        let url = "https://perfectself-avatar-bucket.s3.us-east-2.amazonaws.com/\(item.avatarBucketName)/\(item.avatarKey)"
                        self.readerAvatar.imageFrom(url: URL(string: url)!)
                    }
                    
                    // call API for available time slots
                    
                    webAPI.getAvailabilityById(uid: self.id) {data1, response1, error1 in
                        DispatchQueue.main.async {
                            hideIndicator(sender: nil);
                        }
                        guard let data1 = data1, error1 == nil else {
                            print(error1?.localizedDescription ?? "No data")
                            return
                        }
                        do {
                            let respItems = try JSONDecoder().decode([Availability].self, from: data1)
                            print(respItems)
                            DispatchQueue.main.async {
                                //update availability time slots
                                self.items.removeAll()
                                self.items.append(contentsOf: respItems)
            //                    for (i, reader) in items.enumerated() {
            //                    }
                                self.timeslotList.reloadData()
                            }
                        }
                        catch {
                            DispatchQueue.main.async {
                                Toast.show(message: "Something went wrong. try again later", controller: self)
                            }
                        }
                    }
                }
            }
            catch {
            
                DispatchQueue.main.async {
                    hideIndicator(sender: nil);
                    Toast.show(message: "Something went wrong. try again later", controller: self)
                }
            }
        }
        
    }
    func setupPlayer() {
        playerView.url = videoUrl
        playerView.delegate = self
        slider.minimumValue = 0
    }
    
    @IBAction func UploadVideo(_ sender: UIButton) {
        print("upload video")
    }
    @IBAction func btnPlayPauseClicked(_ sender: UIButton) {
        isPlaying = !isPlaying
        if isPlaying {
            playerView.play()
        }
        else {
            playerView.stop()
        }
//        if playerView.rate > 0 {
//            playerView.pause()
//            isPlaying = false
//        } else {
//           playerView.play()
//           isPlaying = true
//        }
    }
    
    // MARK: - Time Slot List Delegate.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         // myData is the array of items
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//        let totalSpace = flowLayout.sectionInset.top
//        + flowLayout.sectionInset.bottom
//        + (flowLayout.minimumLineSpacing * CGFloat(cellsPerRow - 1))
//        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(cellsPerRow))
        return CGSize(width: 80, height: 74)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Time Slot Collection View Cell", for: indexPath) as! TimeSlotCollectionViewCell

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateFormatter.date(from: self.items[indexPath.row].date)
    
        dateFormatter.dateFormat = "EEE"
        let weekDay = dateFormatter.string(from: date ?? Date())
        
        dateFormatter.dateFormat = "dd MMM"
        let dayMonth = dateFormatter.string(from: date ?? Date())
        
        cell.lbl_num_slot.text = "1 slot";
        cell.lbl_weekday.text = weekDay
        cell.lbl_date_month.text = dayMonth
        // return card
//        cell.layer.masksToBounds = false
//        cell.layer.shadowOffset = CGSizeZero
//        cell.layer.shadowRadius = 8
//        cell.layer.shadowOpacity = 0.2
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // add the code here to perform action on the cell
        print("didDeselectItemAt")
//        let cell = collectionView.cellForItem(at: indexPath) as? LibraryCollectionViewCell
    }
    @IBAction func ShowOverview(_ sender: UIButton) {
        sender.tintColor = UIColor(rgb: 0x4063FF)
        btn_videointro.tintColor = .black
        btn_review.tintColor = .black
        line_overview.isHidden = false
        line_videointro.isHidden = true
        line_review.isHidden = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view_overview.alpha = 1
            self.view_videointro.alpha = 0
            self.view_review.alpha = 0
            self.view_overview.frame.origin.x = 0
            self.view_videointro.frame.origin.x = self.view_container.frame.width
            self.view_review.frame.origin.x = self.view_container.frame.width
        })    
    }
    
    @IBAction func ShowVideoIntro(_ sender: UIButton) {
        sender.tintColor = UIColor(rgb: 0x4063FF)
        btn_overview.tintColor = .black
        btn_review.tintColor = .black
        line_overview.isHidden = true
        line_videointro.isHidden = false
        line_review.isHidden = true
       
        UIView.animate(withDuration: 0.5, animations: {
            self.view_overview.alpha = 0
            self.view_videointro.alpha = 1
            self.view_review.alpha = 0
            self.view_overview.frame.origin.x = -self.view_container.frame.width
            self.view_videointro.frame.origin.x = 0
            self.view_review.frame.origin.x = self.view_container.frame.width
        })
    }
    
    @IBAction func ShowReview(_ sender: UIButton) {
        sender.tintColor = UIColor(rgb: 0x4063FF)
        btn_overview.tintColor = .black
        btn_videointro.tintColor = .black
        line_overview.isHidden = true
        line_videointro.isHidden = true
        line_review.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view_overview.alpha = 0
            self.view_videointro.alpha = 0
            self.view_review.alpha = 1
            self.view_overview.frame.origin.x = -self.view_container.frame.width
            self.view_videointro.frame.origin.x = -self.view_container.frame.width
            self.view_review.frame.origin.x = 0
        })
    }

    @IBAction func EditUserAvatar(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
               
    }
    @IBAction func EditUserInfo(_ sender: UIButton) {
        let controller = ReaderProfileEditPersonalInfoViewController()
        controller.username = readerUsername.text ?? ""
        controller.usertitle = readerTitle.text ?? ""
        controller.uid = id
        controller.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        present(controller, animated: false, completion: nil)
    }
    @IBAction func EditExperience(_ sender: UIButton) {
        let controller = ReaderProfileEditSkillViewController()
        
        controller.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        present(controller, animated: false, completion: nil)
    }
    @IBAction func EditAbout(_ sender: UIButton) {
        let controller = ReaderProfileEditAboutViewController() // Instantiate View Controller B
        controller.uid = id
        controller.about = readerAbout.text
        controller.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        present(controller, animated: false, completion: nil)

    }
    @IBAction func EditSkills(_ sender: UIButton) {
        let controller = ReaderProfileEditSkillViewController()
        
        controller.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        present(controller, animated: false, completion: nil)
    }
    @IBAction func EditAvailability(_ sender: UIButton) {
        let controller = ReaderProfileEditAvailabilityViewController()
        controller.uid = id
        controller.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        present(controller, animated: false, completion: nil)
    }
    @IBAction func EditHourlyRate(_ sender: UIButton) {
        let controller = ReaderProfileEditHourlyRateViewController()
        controller.hourlyrate = hourlyRate
        controller.uid = id
        controller.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        present(controller, animated: false, completion: nil)
    }
    @IBAction func EditProfile(_ sender: UIButton) {

        if isEditingMode {
            isEditingMode = false;
            btn_edit_avatar.isHidden = true;
            btn_edit_userinfo.isHidden = true;
            btn_edit_experience.isHidden = true;
            btn_edit_about.isHidden = true;
            btn_edit_skills.isHidden = true;
            btn_edit_availability.isHidden = true;
            view_edit_hourly_rate.isHidden = true;
        }
        else {
            isEditingMode = true;
            btn_edit_avatar.isHidden = false;
            btn_edit_userinfo.isHidden = false;
            btn_edit_experience.isHidden = false;
            btn_edit_about.isHidden = false;
            btn_edit_skills.isHidden = false;
            btn_edit_availability.isHidden = false;
            view_edit_hourly_rate.isHidden = false;
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

/// Mark:https://perfectself-avatar-bucket.s3.us-east-2.amazonaws.com/{room-id-000-00}/{647730C6-5E86-483A-859E-5FBF05767018.jpeg}
extension ReaderProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let awsUpload = AWSMultipartUpload()
            DispatchQueue.main.async {
                showIndicator(sender: nil, viewController: self, color:UIColor.white)
                Toast.show(message: "Start to upload record files", controller: self)
            }
            
            //Upload audio at first
            guard info[.originalImage] is UIImage else {
                //dismiss(animated: true, completion: nil)
                return
            }
                    
            // Get the URL of the selected image
            var avatarUrl: URL? = nil
            if let imageUrl = info[.imageURL] as? URL {
                avatarUrl = imageUrl
                //Then Upload image
                awsUpload.uploadImage(filePath: avatarUrl!, bucketName: "perfectself-avatar-bucket", prefix: self.id) { (error: Error?) -> Void in
                    if(error == nil)
                    {
                        DispatchQueue.main.async {
                            hideIndicator(sender: nil)
                            Toast.show(message: "Avatar Image upload completed.", controller: self)
                            // update avatar
                            let url = "https://perfectself-avatar-bucket.s3.us-east-2.amazonaws.com/\(self.id)/\(String(describing: avatarUrl!.lastPathComponent))"
                            self.readerAvatar.imageFrom(url: URL(string: url)!)
                            //update user profile
                            webAPI.updateUserAvatar(uid: self.id, bucketName: self.id, avatarKey: String(describing: avatarUrl!.lastPathComponent)) { data, response, error in
                                if error == nil {
                                    // successfully update db
                                    print("update db completed")
                                }
                            }
                            
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            hideIndicator(sender: nil)
                            Toast.show(message: "Failed to upload avatar image, Try again later!", controller: self)
                        }
                    }
                }
            }
        }//DispatchQueue.global
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ReaderProfileViewController: PlayerViewDelegate {
    func playerVideo(player: PlayerView, currentTime: Double) {
        slider.value = Float(currentTime)
    }

    func playerVideo(player: PlayerView, duration: Double) {
        slider.maximumValue =  Float(duration)
    }

    func playerVideo(player: PlayerView, statusItemPlayer: AVPlayer.Status, error: Error?) {
        //
    }

    func playerVideo(player: PlayerView, statusItemPlayer: AVPlayerItem.Status, error: Error?) {
        //
    }

    func playerVideoDidEnd(player: PlayerView) {
        isPlaying = false
    }
}
