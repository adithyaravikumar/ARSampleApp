//
//  ViewModel.swift
//  ARTestApp
//
//  Created by Adi Ravikumar on 2/21/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import Foundation
import ARKit

enum ModelType {
    case box(Float, Float, Float)
    case pyramid( Float, Float, Float)
}

enum ModelError: Error {
    case invalidModelType
    case invalidModelName
    case modelNotParsed
    case unknown
}

enum ModelLighting {
    case none
    case ambient(UIColor, CGFloat)
    
    var light: SCNLight {
        switch self {
        case .none:
            return SCNLight()
        case .ambient(let color, let intensity):
            let ambientLight = SCNLight()
            ambientLight.color = color
            ambientLight.type = SCNLight.LightType.ambient
            ambientLight.intensity = intensity
            return ambientLight
        }
    }
}

class ViewModel {
    
    func virtualObject(ofType modelType: ModelType, withLighting modelLighting: ModelLighting) -> SCNNode {
        let node = SCNNode()
        
        switch modelType {
        case .box(let x, let y, let z):
            node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
            node.position = SCNVector3(x, y, z)
        case .pyramid(let x, let y, let z):
            node.geometry = SCNPyramid(width: 0.1, height: 0.1, length: 0.1)
            node.position = SCNVector3(x, y, z)
        }
        node.light = modelLighting.light
        return node
    }
}
