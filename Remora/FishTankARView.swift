import SwiftUI
import ARKit

struct FishTankARView: UIViewRepresentable {
            
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
