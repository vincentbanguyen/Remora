import SwiftUI
import SceneKit

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
        fishNode.runAction(SCNAction.move(to: SCNVector3Make(5, 0, 5), duration: 0.25))
    }
    
    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.backgroundColor = UIColor.black
        
        let fishNode = setupNodes()!
        moveFish(fishNode: fishNode)
        
    }
}

struct ScenekitView_Previews : PreviewProvider {
    static var previews: some View {
        FishTankView()
    }
}

