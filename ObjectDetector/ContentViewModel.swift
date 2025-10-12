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
    
    
    func detectObject(image : UIImage) {
        guard let ciImage = CIImage(image: image) else {
            return
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
    }
}
