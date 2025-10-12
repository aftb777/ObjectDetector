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
            
        }
        
    }
    
    func detectObject(image : UIImage) {
        
        // Prepare Image
        guard let ciImage = CIImage(image: image) else {
            return
        }
        
        // Create Image Handler
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        // Use our handler
        guard let imageAnalysis = imageAnalysis else { return }
        do {
            try handler.perform([imageAnalysis])
        } catch {
            print(error.localizedDescription)
        }
    }
}
