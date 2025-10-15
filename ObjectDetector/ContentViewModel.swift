//
//  ContentViewModel.swift
//  ObjectDetector
//
//  Created by Aftaab Mulla on 11/10/25.
//

import Foundation
import SwiftUI
import Vision

@Observable
class ContentViewModel {
    
    // Create ML request
    var imageAnalysis : VNCoreMLRequest?
    var detection = "No image Detected"
    
    // Initialize our ML Model
    init() {
        
        // Configure
        let config = MLModelConfiguration()
        guard let resnet = try? Resnet50(configuration: config) else {return}
        
        // create our ML Model instance
        let resnetModel = resnet.model
        guard let resnetVNCoreMLModel = try? VNCoreMLModel(for: resnetModel) else {return}
        
        // pass in to our ML Request
        self.imageAnalysis = VNCoreMLRequest(model: resnetVNCoreMLModel) { (request, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.process(request: request)
        }
        
    }
    
    func detectObject(image : UIImage) {
        detection = ""
        
        // Prepare Image
        guard let ciImage = CIImage(image: image) else {
            return
        }
        
        // Create Image Handler
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
        
        // Use our handler
        guard let imageAnalysis = imageAnalysis else { return }
        do {
            try handler.perform([imageAnalysis])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func process(request : VNRequest) {
        guard let result = request.results as? [VNClassificationObservation],
        let dominantResult = result.first else {
            return
        }
        
        detection = "\(Int(dominantResult.confidence * 100))% \(dominantResult.identifier)"
    }
}
