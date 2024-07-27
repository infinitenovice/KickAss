//
//  MessageSender.swift
//  KickAss
//
//  Created by Infinite Novice on 7/26/24.
//

import SwiftUI
import MessageUI

struct MessageSender: UIViewControllerRepresentable {
    var recipients: [String]
    var message: String
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var completion: () -> Void
        init(completion: @escaping ()->Void) {
            self.completion = completion
        }
        // delegate method
        func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                   didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true, completion: nil)
            completion()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator() {} // not using completion handler
    }
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.recipients = recipients
        vc.body = message
        vc.messageComposeDelegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
    
    typealias UIViewControllerType = MFMessageComposeViewController
}
