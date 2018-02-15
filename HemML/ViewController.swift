//
//  ViewController.swift
//  HemML
//
//  Created by 藤井陽介 on 2017/12/11.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit
import Vision
import SwiftyCam

class ViewController: SwiftyCamViewController {
    
    @IBOutlet weak var button: SwiftyCamButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cameraDelegate = self
        button.delegate = self
        view.bringSubview(toFront: button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func coreMLRequest(_ image: UIImage) {
        // Model
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else {
            
            fatalError("Error create VMCoreMLModel")
        }
        
        // Request
        let request = VNCoreMLRequest(model: model) { request, error in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                
                fatalError("Error results")
            }
            
            if let classification = results.first {
                
                print("identifier = \(classification.identifier)")
                print("confidence = \(classification.confidence)")
            } else {
                
                print("error")
            }
        }
        
        // Convert image to CIImage
        guard let ciImage = CIImage(image: image) else {
            
            fatalError("Error convert CIImage")
        }
        
        // Perform Request
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        guard (try? handler.perform([request])) != nil else {
            
            fatalError("Error handler.perform")
        }
    }
}

extension ViewController: SwiftyCamViewControllerDelegate {
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        
        coreMLRequest(photo)
    }
}

