import SwiftUI
import ARKit

struct FishTankARView: UIViewRepresentable {
    let scene = SCNScene(named: "MainScene.scn")!
    var arView = ARSCNView(frame: .zero)
    
    func makeUIView(context: Context) -> ARSCNView {
        
        arView.scene = scene
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
        
        private func createCubeNode() -> SCNNode {
            // create the basic geometry of the box (sizes are in meters)
            let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)

            // give the box a material to make a little more realistic
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.blue
            material.specular.contents = UIColor(white: 0.6, alpha: 1.0)

            // create the node and give it the materials
            let boxNode = SCNNode(geometry: boxGeometry)
            boxNode.geometry?.materials = [material]

            return boxNode
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
                 
            let cube = createCubeNode()

            cube.transform = SCNMatrix4(result.worldTransform)

            arView.scene.rootNode.addChildNode(cube)
        }
    }
}

struct ARkitView_Previews : PreviewProvider {
    static var previews: some View {
        FishTankARView()
    }
}

