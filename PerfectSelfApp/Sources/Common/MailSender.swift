//
//  MailSender.swift
//  PerfectSelf
//
//  Created by user237184 on 4/4/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import Foundation
import skpsmtpmessage

class MailSender: NSObject, SKPSMTPMessageDelegate {
    static let shared = MailSender()

    func sendEmail(toEmail: String, fromEmail:String,  subject: String, body: String) {
//        let message = SKPSMTPMessage()
//         message.relayHost = "mail.valerasoft.com"//"smtp.gmail.com"
//         message.login = "support@valerasoft.com"//message.login = "maximenkoe2020@gmail.com"
//         message.pass = "123$%^qweRTY"//message.pass = "Maximenkoe=@2020!"
//        //message.validateSSLChain = true
//         message.requiresAuth = true
//         message.wantsSecure = true
//         message.relayPorts = [465]
//         message.fromEmail = fromEmail
//         message.toEmail = toEmail
//         message.subject = subject
//         let messagePart = [kSKPSMTPPartContentTypeKey: "text/plain; charset=UTF-8", kSKPSMTPPartMessageKey: body]
//         message.parts = [messagePart]
//         message.delegate = self
//         message.send()
        
        let message = SKPSMTPMessage()
        message.relayHost = "smtp.office365.com"//"smtp.gmail.com"
        message.login = "greentree619@outlook.com"//message.login = "maximenkoe2020@gmail.com"
        message.pass = "ValeraEgor123"//message.pass = "Maximenkoe=@2020!"
        message.requiresAuth = true
        message.wantsSecure = true
        message.relayPorts = [587]
        message.fromEmail = fromEmail
        message.toEmail = toEmail
        message.subject = subject
        let messagePart = [kSKPSMTPPartContentTypeKey: "text/plain; charset=UTF-8", kSKPSMTPPartMessageKey: body]
        message.parts = [messagePart]
        message.delegate = self
        message.send()
    }

    func messageSent(_ message: SKPSMTPMessage!) {
        print("Successfully sent email!")
    }

    func messageFailed(_ message: SKPSMTPMessage!, error: Error!) {
        print("Sending email failed!")
    }
}
