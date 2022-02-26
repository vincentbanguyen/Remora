import SwiftUI
import SceneKit
import SCNBezier

struct FishTankView : UIViewRepresentable {
    let scene = SCNScene(named: "MainScene.scn")!
    
    func makeUIView(context: Context) -> SCNView {
        
        // can do camera progarmmaticaly or in mainScene
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        scene.rootNode.addChildNode(cameraNode)
//
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 100)
        
        let scnView = SCNView()
        return scnView
    }
    
    func setupNodes() -> SCNNode? {
        let fishNode = scene.rootNode.childNode(withName: "fish", recursively: true)!
        return fishNode
    }
    
    func moveFish(fishNode: SCNNode){
        fishNode.runAction(SCNAction.move(to: SCNVector3Make(0, 0, -4), duration: 10))
    }
    
    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.backgroundColor = UIColor.black
        
        let fishNode = setupNodes()!
//        moveFish(fishNode: fishNode)
        let bezPositions = [
          SCNVector3(-1, 1, 0.01),
          SCNVector3(1, 0.5, 0.4),
          SCNVector3(1.0, -1, 0.1),
          SCNVector3(0.4, -0.5, 0.01),
          SCNVector3(-1, 1, 0.01)
        ]
        fishNode.runAction(SCNAction.repeatForever(.moveAlong(bezier: bezPositions, duration: 3)))
        
    }
}

struct ScenekitView_Previews : PreviewProvider {
    static var previews: some View {
        FishTankView()
    }
}

