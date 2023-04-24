//
//  ReaderProfileEditAvailabilityViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import FSCalendar

class ReaderProfileEditAvailabilityViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, RemoveDelegate{
    func didRemoveTimeSlot(index: Int, repeatFlag: Int) {
        if repeatFlag == 0 {
            if let indexOf = timeSlotItems.firstIndex(where: { $0.date == items[index].date && $0.fromTime == items[index].fromTime && $0.toTime == items[index].toTime }) {
                timeSlotItems.remove(at: indexOf)
                SelectedDateChanged(picker_date)
            }
        }
        else {
            currentIndex = index
            currentRepeatFlag = repeatFlag
            backView.isHidden = false
            confirmModal.isHidden = false
        }
    }
    
    var uid : String = ""
    @IBOutlet weak var picker_date: UIDatePicker!
    @IBOutlet weak var timeslotList: UICollectionView!
    @IBOutlet weak var calendar: FSCalendar!
    var timeSlotItems = [TimeSlot]()
    var items = [TimeSlot]()
    let cellsPerRow = 1
    var currentIndex = 0
    var currentRepeatFlag = 0
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    @IBOutlet weak var confirmModal: UIStackView!
    @IBOutlet weak var backView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "TempTimeSlotCollectionViewCell", bundle: nil)
        timeslotList.register(nib, forCellWithReuseIdentifier: "Temp Time Slot Collection View Cell")
        timeslotList.dataSource = self
        timeslotList.delegate = self
        timeslotList.allowsSelection = true
        // Do any additional setup after loading the view.
        backView.isHidden = true
        confirmModal.isHidden = true
        dateFormatter.dateFormat = "yyyy-MM-dd"
        timeFormatter.dateFormat = "hh:mm"
        print(timeSlotItems)
        
        calendar.dataSource = self
        calendar.delegate = self
    }
 
    @IBAction func RemoveThisSlot(_ sender: UIButton) {
        if let indexOf = timeSlotItems.firstIndex(where: { $0.date == items[currentIndex].date && $0.fromTime == items[currentIndex].fromTime && $0.toTime == items[currentIndex].toTime }) {
            let currentDate = dateFormatter.date(from: items[currentIndex].date)
            let calendar = Calendar.current
            // Edit date
            if currentRepeatFlag == 1 {
                // Add 1 day to the current date
                let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate ?? Date())
                timeSlotItems[indexOf].date = dateFormatter.string(from: nextDay!)
            }
            else if currentRepeatFlag == 2 {
                // Add 1 week1 to the current date
                let nextWeek = calendar.date(byAdding: .weekOfMonth, value: 1, to: currentDate ?? Date())
                timeSlotItems[indexOf].date = dateFormatter.string(from: nextWeek!)
            }
            else if currentRepeatFlag == 3 {
                // Add 1 months to the current date
                let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate ?? Date())
                timeSlotItems[indexOf].date = dateFormatter.string(from: nextMonth!)
            }
            else {
                print("oops!")
            }
            
            SelectedDateChanged(picker_date)
        }
        backView.isHidden = true
        confirmModal.isHidden = true
    }
    @IBAction func RemoveAllTimeSlot(_ sender: UIButton) {
        if let indexOf = timeSlotItems.firstIndex(where: { $0.date == items[currentIndex].date && $0.fromTime == items[currentIndex].fromTime && $0.toTime == items[currentIndex].toTime }) {
            timeSlotItems.remove(at: indexOf)
            SelectedDateChanged(picker_date)
        }
        backView.isHidden = true
        confirmModal.isHidden = true
    }
    @IBAction func CancelRemove(_ sender: UIButton) {
        backView.isHidden = true
        confirmModal.isHidden = true
    }
    @IBAction func SelectedDateChanged(_ sender: UIDatePicker) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        items = timeSlotItems.filter { dateFormatter.string(from: df.date(from: $0.date)!) == dateFormatter.string(from: sender.date) }
        timeslotList.reloadData()
    }
    @IBAction func AddTimeSlot(_ sender: UIButton) {
        let controller = TimeSelectPopUpViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: true)
    }
 
    @IBAction func SaveChanges(_ sender: UIButton) {
       // call API for save changes
        webAPI.updateAvailability(uid: uid, timeSlotList: timeSlotItems) { data, response, error in
            guard let _ = data, error == nil else {
                DispatchQueue.main.async {
                    Toast.show(message: "Something went wrong!, try agian later.", controller: self)
                }
                return
            }
            DispatchQueue.main.async {
                Toast.show(message: "Availability Updated!", controller: self)
            }
        }
        
    }
    @IBAction func GoBack(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) //  Add transition to window layer
        self.dismiss(animated: true)
    }
    // MARK: - Time Slot List Delegate.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         // myData is the array of items
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.top
        + flowLayout.sectionInset.bottom
        + (flowLayout.minimumLineSpacing * CGFloat(cellsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(cellsPerRow))
        return CGSize(width: size, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Temp Time Slot Collection View Cell", for: indexPath) as! TempTimeSlotCollectionViewCell

        cell.delegate = self
        cell.index = indexPath.row
        cell.repeatFlag = items[indexPath.row].repeatFlag
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let fromT = df.date(from: items[indexPath.row].fromTime)!
        let toT = df.date(from: items[indexPath.row].toTime)!
        cell.timeslot.text = timeFormatter.string(from: fromT) + " - " + timeFormatter.string(from: toT)
        // return card
//        cell.layer.masksToBounds = false
//        cell.layer.shadowOffset = CGSizeZero
//        cell.layer.shadowRadius = 8
//        cell.layer.shadowOpacity = 0.2
//        cell.contentView.layer.cornerRadius = 12
//        cell.contentView.layer.borderWidth = 1.0
//        cell.contentView.layer.borderColor = UIColor.gray.cgColor
//        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // add the code here to perform action on the cell
        print("didDeselectItemAt")
//        let cell = collectionView.cellForItem(at: indexPath) as? LibraryCollectionViewCell
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
extension ReaderProfileEditAvailabilityViewController: MyDelegate {
    func didUpdateTimeSlot(fromTime: Date, toTime: Date, repeatFlag: Int, isStandBy: Bool) {
        timeSlotItems.append(TimeSlot(date: Date.getDateString(date: picker_date.date), fromTime: Date.getDateString(date: fromTime), toTime: Date.getDateString(date: toTime), repeatFlag: repeatFlag, isStandBy: isStandBy))
        SelectedDateChanged(picker_date)
    }
}

extension ReaderProfileEditAvailabilityViewController: FSCalendarDataSource, FSCalendarDelegate {
    
}
