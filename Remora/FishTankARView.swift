import SwiftUI
import ARKit

struct FishTankARView: UIViewRepresentable {
    let scene = SCNScene(named: "art.scnassets/ship.scn")!
    sceneView.scene = scene
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView) else {
          print("Couldn't find location!")
          return
        }

        guard let query = sceneView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .horizontal) else {
          print("Couldn't create a query!")
          return
        }

        guard let result = sceneView.session.raycast(query).first else {
          print("Couldn't match the raycast with a plane.")
          return
        }
             
        let cube = createCubeNode()

        cube.transform = SCNMatrix4(result.worldTransform)

        sceneView.scene.rootNode.addChildNode(cube)
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
    
    func makeUIView(context: Context) -> ARSCNView {
            
        let arView = ARSCNView(frame: .zero)
            
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
            
        // Run the view's session
        arView.session.run(configuration)
        
        // FISH STUFF
            
        return arView
    }
        
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        
    }
}
