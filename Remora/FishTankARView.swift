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
        
        func setupCubeNode() -> SCNNode? {
            guard let cubeNode = scene.rootNode.childNode(withName: "Cube-001", recursively: true)
            else {return nil}
            return cubeNode
        }
        
        func setupTankNode() -> SCNNode? {
            guard let tankNode = scene.rootNode.childNode(withName: "Tank", recursively: true)
            else {return nil}
            return tankNode
        }
        
        func setupBoxNode() -> SCNNode? {
            guard let tankNode = scene.rootNode.childNode(withName: "Box", recursively: true)
            else {return nil}
            return tankNode
        }
        
        func fixedNodeYPos(tempNode: SCNNode) -> SCNVector3 {
            return SCNVector3Make(tempNode.position.x, tempNode.position.y + 0.05, tempNode.position.z)
        }
        
        func setWaterLevel(waterLevel: Int) -> SCNVector3 {
            if waterLevel <= 0 {
                return SCNVector3Make(0.06, 0, 0.06)
            }
            print("water level: " + String(waterLevel))
            return SCNVector3Make(0.06, 0.06 - Float(waterLevel/100), 0.06)
        }
        
        func moveFish(node: SCNNode) {
            let bezPositions = [
                SCNVector3(node.position.x + 0.03, node.position.y + 0, node.position.z + 0),
                SCNVector3(node.position.x + 0, node.position.y + 0.02, node.position.z + 0.1),
                SCNVector3(node.position.x - 0.02, node.position.y - 0.01, node.position.z - 0.01),
                SCNVector3(node.position.x - 0.03, node.position.y - 0.01, node.position.z - 0.01),
                SCNVector3(node.position.x - 0.04, node.position.y - 0.02, node.position.z - 0.01),
                SCNVector3(node.position.x - 0.01, node.position.y - 0.02, node.position.z - 0.01),
                SCNVector3(node.position.x + 0.03, node.position.y + 0, node.position.z + 0)
            ]
            node.runAction(SCNAction.repeatForever(.moveAlong(bezier: bezPositions, duration: 8)))
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
                if (node.name == "Armature") {
                    node.transform = SCNMatrix4(result.worldTransform)
                    let tempNode = node
                    tempNode.scale = SCNVector3Make(0.01, 0.01, 0.01)
                    tempNode.position = fixedNodeYPos(tempNode: tempNode)
                    node.removeFromParentNode()
                    arView.scene.rootNode.addChildNode(tempNode)
                    moveFish(node: tempNode)
                }
                if (node.name == "Cube-001") {
                    node.transform = SCNMatrix4(result.worldTransform)
                    let tempNode = node
                    tempNode.scale = SCNVector3Make(0.00001, 0.00001, 0.00001)
                    tempNode.position = fixedNodeYPos(tempNode: tempNode)
                    print(tempNode.position)
                    node.removeFromParentNode()
                    print(tempNode.scale)
                    arView.scene.rootNode.addChildNode(tempNode)
                }
                if (node.name == "Tank") {
                    node.transform = SCNMatrix4(result.worldTransform)
                    let tempNode = node
                    tempNode.scale = SCNVector3Make(0.06, 0.06, 0.06)
                    tempNode.position = fixedNodeYPos(tempNode: tempNode)
                    tempNode.opacity = 0.5
                    print(tempNode.position)
                    node.removeFromParentNode()
                    print(tempNode.scale)
                    arView.scene.rootNode.addChildNode(tempNode)
                }
                if (node.name == "Box") {
                    node.transform = SCNMatrix4(result.worldTransform)
                    let tempNode = node
                    tempNode.scale = setWaterLevel(waterLevel: UserDefaults.standard.integer(forKey: "waterLeft"))
                    tempNode.position = fixedNodeYPos(tempNode: tempNode)
                    tempNode.opacity = 0.9
                    print(tempNode.position)
                    node.removeFromParentNode()
                    print(tempNode.scale)
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
                moveFish(node: tempNode!)
            }
            
            let cubeNode = setupCubeNode()
            cubeNode?.transform = SCNMatrix4(result.worldTransform)
            let tempNode2 = cubeNode
            tempNode2?.position = fixedNodeYPos(tempNode: tempNode2!)
            tempNode2?.scale = SCNVector3Make(0.00001, 0.00001, 0.00001)
            if(tempNode2 != nil) {
                print(tempNode2?.scale)
           //     arView.scene.rootNode.addChildNode(tempNode2!)
            }
            
            let tankNode = setupTankNode()
            tankNode?.transform = SCNMatrix4(result.worldTransform)
            let tempNode3 = tankNode
            tempNode3?.position = fixedNodeYPos(tempNode: tempNode3!)
            tempNode3?.scale = SCNVector3Make(0.06, 0.06, 0.06)
            tempNode3?.opacity = 0.5
            if(tempNode3 != nil) {
         //       arView.scene.rootNode.addChildNode(tempNode3!)
            }
            
            let boxNode = setupBoxNode()
            boxNode?.transform = SCNMatrix4(result.worldTransform)
            let tempNode4 = boxNode
            tempNode4?.position = fixedNodeYPos(tempNode: tempNode4!)
            tempNode4?.scale = setWaterLevel(waterLevel: UserDefaults.standard.integer(forKey: "waterLeft"))
            tempNode4?.opacity = 0.9
            if(tempNode4 != nil) {
                arView.scene.rootNode.addChildNode(tempNode4!)
            }
        }
    }
}

struct ARkitView_Previews : PreviewProvider {
    static var previews: some View {
        FishTankARView()
    }
}


