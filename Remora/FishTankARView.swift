import SwiftUI
import ARKit

struct FishTankARView: UIViewRepresentable {
    let scene = SCNScene(named: "MainScene.scn")!
    var arView = ARSCNView(frame: .zero)
    
    func makeUIView(context: Context) -> ARSCNView {
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        tapGesture.delegate = context.coordinator
        arView.addGestureRecognizer(tapGesture)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
            
        // Run the view's session
        arView.session.run(configuration)
        
        // FISH STUFF
            
        return arView
    }
        
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(arView, scene)
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        private let arView: ARSCNView
        private let scene: SCNScene
        init(_ arView: ARSCNView, _ scene: SCNScene) {
            self.arView = arView
            self.scene = scene
            super.init()
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        func setupFishNode() -> SCNNode? {
            guard let fishNode = scene.rootNode.childNode(withName: "Armature", recursively: true)
            else {return nil}
            return fishNode
        }
        
        func fixedNodeYPos(tempNode: SCNNode) -> SCNVector3 {
            return SCNVector3Make(tempNode.position.x, tempNode.position.y + 0.05, tempNode.position.z)
        }
        
        func setupTankNode() -> SCNNode? {
            guard let tankNode = scene.rootNode.childNode(withName: "tank", recursively: true)
            else {return nil}
            return tankNode
        }
        
        @objc func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
            let location = gestureRecognize.location(in: arView)
            
            guard let query = arView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .horizontal) else {
              print("Couldn't create a query!")
              return
            }

            guard let result = arView.session.raycast(query).first else {
              print("Couldn't match the raycast with a plane.")
              return
            }
            
            arView.scene.rootNode.enumerateChildNodes { (node, stop) in
                if (node.name == "Armature-001") {
                    node.transform = SCNMatrix4(result.worldTransform)
                    let tempNode = node
                    tempNode.scale = SCNVector3Make(0.01, 0.01, 0.01)
                    tempNode.position = fixedNodeYPos(tempNode: tempNode)
                    node.removeFromParentNode()
                    arView.scene.rootNode.addChildNode(tempNode)
                }
                if (node.name == "tank") {
                    node.transform = SCNMatrix4(result.worldTransform)
                    let tempNode = node
                    tempNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
                    tempNode.position = fixedNodeYPos(tempNode: tempNode)
                    node.removeFromParentNode()
                    arView.scene.rootNode.addChildNode(tempNode)
                }
                print("set new pos")
            }
            let fishNode = setupFishNode()
            fishNode?.transform = SCNMatrix4(result.worldTransform)
            let tempNode = fishNode
            tempNode?.scale = SCNVector3Make(0.01, 0.01, 0.01)
            tempNode?.position = fixedNodeYPos(tempNode: tempNode!)
            if(tempNode != nil) {
                arView.scene.rootNode.addChildNode(tempNode!)
            }
            
            let tankNode = setupTankNode()
            tankNode?.transform = SCNMatrix4(result.worldTransform)
            let tempNode2 = tankNode
            tempNode2?.position = fixedNodeYPos(tempNode: tempNode2!)
            tempNode2?.scale = SCNVector3Make(0.1, 0.1, 0.1)
            if(tempNode2 != nil) {
                arView.scene.rootNode.addChildNode(tempNode2!)
            }
        }
    }
}

struct ARkitView_Previews : PreviewProvider {
    static var previews: some View {
        FishTankARView()
    }
}


