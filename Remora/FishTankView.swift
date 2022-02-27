import SwiftUI
import SceneKit
import SCNBezier

struct FishTankView: UIViewRepresentable {
    let scene = SCNScene(named: "MainScene.scn")!
    
    var view = SCNView()
    
    func makeUIView(context: Context) -> SCNView {
        let cameraNode = scene.rootNode.childNode(withName: "camera", recursively: true)!
        
        let fishNode = setupNodes()!
        setUpCamera()
        view.scene = scene
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        panGesture.delegate = context.coordinator
        view.addGestureRecognizer(panGesture)
        
        moveFish(fishNode: fishNode)
        let bezPositions = [
          SCNVector3(-1, 1, 0.01),
          SCNVector3(1, 0.5, 0.4),
          SCNVector3(1.0, -1, 0.1),
          SCNVector3(0.4, -0.5, 0.01),
          SCNVector3(-1, 1, 0.01)
        ]
        
        
        fishNode.runAction(SCNAction.repeatForever(.moveAlong(bezier: bezPositions, duration: 3)))
        return view
    }
    
    func setupNodes() -> SCNNode? {
        let fishNode = scene.rootNode.childNode(withName: "Armature-001", recursively: true)!
        return fishNode
    }
    
    func setUpCamera() {
        let cameraNode = scene.rootNode.childNode(withName: "camera", recursively: true)!
        
        // record start value
        let cameraXStart = cameraNode.position.x
        let cameraYStart = cameraNode.position.y
        let cameraZStart = cameraNode.position.z - 1.0
        
        let cameraAngleStartZ = cameraNode.eulerAngles.z
        let cameraAngleStartX = cameraNode.eulerAngles.x
        let radiusSquare = cameraXStart * cameraXStart + cameraYStart * cameraYStart + cameraZStart * cameraZStart
        
        // get new Value
        var cameraNewAngleZ = cameraAngleStartZ
        var cameraNewAngleX = cameraAngleStartX
        
        if cameraNewAngleZ >= 100 * Float.pi {
            cameraNewAngleZ = cameraNewAngleZ - 100 * Float.pi
        } else if cameraNewAngleZ < -100 * Float.pi {
            cameraNewAngleZ = cameraNewAngleZ + 100 * Float.pi
        } else {
            // set limit
            if cameraNewAngleX > 1.4 {
                cameraNewAngleX = 1.4
            } else if cameraNewAngleX < 0.1 {
                cameraNewAngleX = 0.1
            }
            // use angle value to get position value
            let cameraNewX =  sqrt(radiusSquare) * cos(cameraNewAngleZ - Float.pi/2) * cos(cameraNewAngleX - Float.pi/2)
            let cameraNewY =  sqrt(radiusSquare) * sin(cameraNewAngleZ - Float.pi/2) * cos(cameraNewAngleX - Float.pi/2)
            let cameraNewZ = -sqrt(radiusSquare) * sin(cameraNewAngleX - Float.pi/2) + 1
            
            if cameraNode.camera?.usesOrthographicProjection == false {
                cameraNode.position = SCNVector3Make(cameraNewX, cameraNewY, cameraNewZ)
                cameraNode.eulerAngles = SCNVector3Make(cameraNewAngleX, 0, cameraNewAngleZ)
            }
            else if cameraNode.camera?.usesOrthographicProjection == true {
                cameraNode.position = SCNVector3Make(0, 0, 10)
                cameraNode.eulerAngles = SCNVector3Make(0, 0, cameraNewAngleZ)
            }
        }
    }
    
    func moveFish(fishNode: SCNNode){
        fishNode.runAction(SCNAction.move(to: SCNVector3Make(0, 0, -4), duration: 10))
    }
    
    func updateUIView(_ scnView: SCNView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(view, scene)
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        private let view: SCNView
        private let scene: SCNScene
        init(_ view: SCNView, _ scene: SCNScene) {
            self.view = view
            self.scene = scene
            super.init()
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        @objc func handlePan(_ gestureRecognize: UIPanGestureRecognizer) {
            // save node data and pan gesture data
            let cameraNode = scene.rootNode.childNode(withName: "camera", recursively: true)!
            
            let speed = gestureRecognize.velocity(in: gestureRecognize.view!)
            var speedX = sign(Float(speed.x)) * Float(sqrt(abs(speed.x)))
            var speedY = sign(Float(speed.y)) * Float(sqrt(abs(speed.y)))
            if speedX.isNaN {speedX = 0}
            if speedY.isNaN {speedY = 0}
            
            // record start value
            let cameraXStart = cameraNode.position.x
            let cameraYStart = cameraNode.position.y
            let cameraZStart = cameraNode.position.z - 1.0
            
            let cameraAngleStartZ = cameraNode.eulerAngles.z
            let cameraAngleStartX = cameraNode.eulerAngles.x
            let radiusSquare = cameraXStart * cameraXStart + cameraYStart * cameraYStart + cameraZStart * cameraZStart
            
            // calculate delta value
            let deltaAngleZ = -0.003 * Float(speedX)
            let deltaAngleX = -0.003 * Float(speedY)
            
            // get new Value
            var cameraNewAngleZ = cameraAngleStartZ + deltaAngleZ
            var cameraNewAngleX = cameraAngleStartX + deltaAngleX
            
            if cameraNewAngleZ >= 100 * Float.pi {
                cameraNewAngleZ = cameraNewAngleZ - 100 * Float.pi
            } else if cameraNewAngleZ < -100 * Float.pi {
                cameraNewAngleZ = cameraNewAngleZ + 100 * Float.pi
            } else {
                // set limit
                if cameraNewAngleX > 1.4 {
                    cameraNewAngleX = 1.4
                } else if cameraNewAngleX < 0.1 {
                    cameraNewAngleX = 0.1
                }
                // use angle value to get position value
                let cameraNewX =  sqrt(radiusSquare) * cos(cameraNewAngleZ - Float.pi/2) * cos(cameraNewAngleX - Float.pi/2)
                let cameraNewY =  sqrt(radiusSquare) * sin(cameraNewAngleZ - Float.pi/2) * cos(cameraNewAngleX - Float.pi/2)
                let cameraNewZ = -sqrt(radiusSquare) * sin(cameraNewAngleX - Float.pi/2) + 1
                
                if cameraNode.camera?.usesOrthographicProjection == false {
                    cameraNode.position = SCNVector3Make(cameraNewX, cameraNewY, cameraNewZ)
                    cameraNode.eulerAngles = SCNVector3Make(cameraNewAngleX, 0, cameraNewAngleZ)
                }
                else if cameraNode.camera?.usesOrthographicProjection == true {
                    cameraNode.position = SCNVector3Make(0, 0, 10)
                    cameraNode.eulerAngles = SCNVector3Make(0, 0, cameraNewAngleZ)
                }
            }
        }
    }
}


struct ScenekitView_Previews : PreviewProvider {
    static var previews: some View {
        FishTankView()
    }
}

