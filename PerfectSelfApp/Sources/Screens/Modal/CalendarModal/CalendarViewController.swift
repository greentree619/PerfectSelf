//
//  CalendarViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/15/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import FSCalendar

public protocol PopUpModalDelegate: AnyObject {
    func didTapCancel()
    func didTapAccept()
}

class CalendarViewController: UIViewController {
    
    private static func create(
        delegate: PopUpModalDelegate
    ) -> CalendarViewController {
        let view = CalendarViewController(delegate: delegate)
        return view
    }
    
    @discardableResult
    static public func present(
        initialView: UIViewController,
        delegate: PopUpModalDelegate
    ) -> CalendarViewController {
        let view = CalendarViewController.create(delegate: delegate)
        view.modalPresentationStyle = .overFullScreen
        view.modalTransitionStyle = .coverVertical
        initialView.present(view, animated: true)
        return view
    }
    
    public init(delegate: PopUpModalDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public weak var delegate: PopUpModalDelegate?
    
    private lazy var canvas: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    private lazy var stackcanvas: UIStackView = {
        let sv = UIStackView();
        sv.axis = .vertical;
        sv.backgroundColor = .green;
        sv.widthAnchor.constraint(equalToConstant: 200).isActive = true;
        sv.heightAnchor.constraint(equalToConstant: 200).isActive = true;
        return sv;
    }()
    private lazy var cancelButton: UIButton = {
        let b: UIButton = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = UIColor(rgb: 0xF8F8F8);
        b.setTitle("Cancel", for: .normal)
        b.addTarget(self, action: #selector(self.didTapCancel(_:)), for: .touchUpInside)
        b.clipsToBounds = true
        b.cornerRadius = 5
        return b
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    @objc func didTapCancel(_ btn: UIButton) {
        self.delegate?.didTapCancel()
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.view.addSubview(canvas);
//        self.canvas.addSubview(cancelButton)
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width*0.7, height: self.view.bounds.width*0.7))
//        calendar.dataSource = self
//        calendar.delegate = self
//        view.addSubview(calendar)
        self.canvas.addSubview(calendar);
//        self.canvas.addSubview(stackcanvas);
//        self.canvas.addSubview(cancelButton);
        
        NSLayoutConstraint.activate([
            self.canvas.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.canvas.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.canvas.widthAnchor.constraint(equalToConstant: self.view.bounds.width*0.7),
            self.canvas.heightAnchor.constraint(equalToConstant:self.view.bounds.width*0.7)
//            self.stackcanvas.heightAnchor.constraint(equalToConstant: 280),
//            self.stackcanvas.widthAnchor.constraint(equalToConstant: 280),
//            self.calendar.centerXAnchor.constraint(equalTo: self.canvas.centerXAnchor),
//            self.calendar.centerYAnchor.constraint(equalTo: self.canvas.centerYAnchor),
//            self.cancelButton.heightAnchor.constraint(equalToConstant: 20),
//            self.cancelButton.widthAnchor.constraint(equalToConstant: 60),
//            self.cancelButton.centerXAnchor.constraint(equalTo: self.canvas.centerXAnchor),
//            self.cancelButton.centerYAnchor.constraint(equalTo: self.canvas.centerYAnchor)
        ])
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
