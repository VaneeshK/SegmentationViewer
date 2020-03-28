//
//  ARViewController.swift
//  ARML
//
//  Created by Vaneesh on 28/03/2020.
//  Copyright © 2020 All rights reserved.
//

import ARKit
import CoreML
import Vision

public class ARViewController: UIViewController, ARSessionDelegate, ARSCNViewDelegate {
    // MARK: - Variables

    let sceneView = ARSCNView()
    var currentBuffer: CVPixelBuffer?
    var previewView = UIImageView()

    // MARK: - Lifecycle

    override public func loadView() {
        super.loadView()

        view = sceneView

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Enable Horizontal plane detection
        configuration.planeDetection = .horizontal

        sceneView.autoenablesDefaultLighting = true
        // Disabled because of random crash
        configuration.environmentTexturing = .none
        
        if #available(iOS 13.0, *) {
            configuration.frameSemantics.insert(.personSegmentation)
        } else {
            // Fallback on earlier versions
        }
        // We want to receive the frames from the video
        sceneView.session.delegate = self

        // Run the session with the configuration
        sceneView.session.run(configuration)

        // The delegate is used to receive ARAnchors when they are detected.
        sceneView.delegate = self

        view.addSubview(previewView)

        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

       
    }


    // MARK: - ARSessionDelegate

    public func session(_: ARSession, didUpdate frame: ARFrame) {

        if #available(iOS 13.0, *), frame.segmentationBuffer != nil {
            self.previewView.image = UIImage(ciImage: CIImage(cvPixelBuffer: frame.segmentationBuffer!)).rotate(radians: (.pi / 2))
        } else {
            return
        }
 
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
