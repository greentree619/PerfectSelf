//
//  ActorSetPaymentViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/15/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import AnimatedCardInput
import Stripe

class ActorSetPaymentViewController: UIViewController {
    var readerUid: String = ""
    var readerName: String = ""
    var bookingStartTime: String = ""
    var bookingEndTime: String = ""
    var bookingDate: String = ""
    var script: String = ""
    var scriptBucket: String = ""
    var scriptKey: String = ""
    var myCardView: CardView?
    
    @IBOutlet weak var cardView: UIStackView!
    @IBOutlet weak var btn_credit: UIButton!
    @IBOutlet weak var btn_paypal: UIButton!
    @IBOutlet weak var btn_applepay: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myCardView = CardView(
            cardNumberDigitsLimit: 16,
            cardNumberChunkLengths: [4, 4, 4, 4],
            CVVNumberDigitsLimit: 3
        )
        cardView.addSubview(myCardView!)
        NSLayoutConstraint.activate([
            myCardView!.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            myCardView!.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            myCardView!.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20)
        ])
    }

    @IBAction func SelectCreditCardPay(_ sender: UIButton) {
        btn_credit.isSelected = true
        btn_applepay.isSelected = false
        btn_paypal.isSelected = false
    }
    
    @IBAction func SelectApplePay(_ sender: UIButton) {
        btn_credit.isSelected = false
        btn_applepay.isSelected = true
        btn_paypal.isSelected = false
    }
    
    @IBAction func SelectPayPal(_ sender: UIButton) {
        btn_credit.isSelected = false
        btn_applepay.isSelected = false
        btn_paypal.isSelected = true
    }
    @IBAction func DoCheckout(_ sender: UIButton) {
        if( btn_credit.isSelected )
        {
            //print(myCardView!.creditCardData.cardNumber)
            payByCreditCard()
        }
        else if( btn_applepay.isSelected )
        {
            payByApplePay()
        }
        else if( btn_paypal.isSelected )
        {
            payByPaypal()
        }
        
        let controller = ActorBookConfirmationViewController();
        controller.readerUid = readerUid
        controller.readerName = readerName
        controller.bookingStartTime = bookingStartTime
        controller.bookingEndTime = bookingEndTime
        controller.bookingDate = bookingDate
        controller.script = script
        controller.scriptBucket = self.scriptBucket
        controller.scriptKey = self.scriptKey
        controller.modalPresentationStyle = .fullScreen
        
//        let transition = CATransition()
//        transition.duration = 0.5 // Set animation duration
//        transition.type = CATransitionType.push // Set transition type to push
//        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
//        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.present(controller, animated: false)
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        
        self.dismiss(animated: false)
    }
    
    func payByCreditCard()
    {
        StripeAPI.defaultPublishableKey = "pk_test_51HvalAIfcqentEpOgDCqVQt4P3E88TyEt1nLEByzKCCDbxtTLcuwx089AHqlRvVpRvPZljWZTNC1OFm9X2PhmxXE00tr5qm63c"
        let paymentIntentClientSecret: String = "sk_test_51HvalAIfcqentEpOEIb4H5XbZ8Hd7fGHCU7jgVWlwBttuNAi8XGDSmklvPaZdsSY2ADFhlSPi7FUhgziJ2BqKAhv00svNrGOE7"
        
        let cardParams = STPPaymentMethodCardParams()
        cardParams.number = "4242424242424242" // Replace with actual card number
        cardParams.expMonth = 12
        cardParams.expYear = 2034
        cardParams.cvc = "567" // Replace with actual CVC code
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
                
        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(paymentIntentParams, with: self) {(status, paymentIntent, error) in
            switch (status) {
            case .failed:
                print("Payment failed")
                print(error as Any)
                
                break
            case .canceled:
                print("Payment canceled")
                
                break
            case .succeeded:
                print("Payment succeeded")
                
                break
            @unknown default:
                fatalError()
                break
            }
        }
        
//
//        STPAPIClient.shared.createPaymentMethod(with: paymentMethodParams) { (paymentMethod, error) in
//            if let error = error {
//                // Handle error
//                print("Error creating payment method: \(error.localizedDescription)")
//                return
//            }
//
//            guard let paymentMethodId = paymentMethod?.stripeId else {
//                // Handle error
//                return
//            }
//
//            // Charge the payment using the Stripe API
//            let paymentIntentParams = STPPaymentIntentParams(clientSecret: "pk_test_51HvalAIfcqentEpOgDCqVQt4P3E88TyEt1nLEByzKCCDbxtTLcuwx089AHqlRvVpRvPZljWZTNC1OFm9X2PhmxXE00tr5qm63c")
//            paymentIntentParams.paymentMethodId = paymentMethodId
//            STPPaymentHandler.shared().confirmPayment( paymentIntentParams, with:  self) { (status, paymentIntent, error) in
//                if let error = error {
//                    // Handle error
//                    print("Error processing payment: \(error.localizedDescription)")
//                    return
//                }
//
//                // Payment successful
//                print("Payment successful!")
//            }
//        }
    }
    
    func payByApplePay()
    {
        
    }
    
    func payByPaypal()
    {
        
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

extension ActorSetPaymentViewController: STPAuthenticationContext{
    func authenticationPresentingViewController() -> UIViewController {
        // Replace with your actual authentication view controller
            let authenticationVC = AuthenticationViewController()
            
            // Customize the presentation style if desired
            authenticationVC.modalPresentationStyle = .fullScreen
            
            return authenticationVC
    }
}
