//
//  ViewController.swift
//  ARTestApp
//
//  Created by Adi Ravikumar on 2/18/19.
//  Copyright © 2019 aravikumar. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    // MVVM View Model
    let viewModel = ViewModel()

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else {
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                showModel(ofType: .box(translation.x, translation.y, translation.z), withLighting: .ambient(UIColor.white, 0.5))
                
            }
            return
        }
        node.removeFromParentNode()
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

private extension ViewController {
    func showModel(ofType modelType: ModelType, withLighting lighting: ModelLighting) {
        let node = viewModel.virtualObject(ofType: modelType, withLighting: lighting)
        present(node: node)
    }
    
    func present(node: SCNNode) {
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
}
