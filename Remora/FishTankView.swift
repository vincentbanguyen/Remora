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

    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.backgroundColor = UIColor.black
    }
}

struct ScenekitView_Previews : PreviewProvider {
    static var previews: some View {
        FishTankView()
    }
}

