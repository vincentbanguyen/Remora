//
//  GameViewController.swift
//  testing iOS
//
//  Created by Randy Thai on 2/25/22.
// Change

import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    var sceneView:SCNView!
    var scene:SCNScene!
    
    override func viewDidLoad() {
        setupScene()
    }
    
    func setupScene(){
        sceneView = self.view as! SCNView
        sceneView.allowsCameraControl = true
        scene = SCNScene(named: "sceneAssets/MainScene.scn")
        sceneView.scene = scene
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
