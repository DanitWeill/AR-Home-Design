//
//  ARRoomVC.swift
//  AR Home Design
//
//  Created by Danit on 15/06/2022.
//

import UIKit
import ARKit

class ARRoomVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ARSCNViewDelegate {
    
    @IBOutlet weak var ARRoomCollectionView: UICollectionView!
    var imageToPass:Array<String>  = []
    @objc let image = ARRoomCollectionViewCell().chosenImageInCell
    
    var chooseImageBool: Bool = false
    var selectedItem: String?
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var upArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var downArrow: UIImageView!
    @IBOutlet weak var leftArrow: UIImageView!
    var leftArrowMove: Bool = false
    
    var node = SCNNode()
    var nodePosition = SCNVector3()
    var moveX = 0.0
    var moveZ = 0.0
    
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        self.ARRoomCollectionView.delegate = self
        self.ARRoomCollectionView.dataSource = self
        self.registerGestureRecognizer()
        self.sceneView.autoenablesDefaultLighting = true
        
        ARRoomCollectionView.register(ARRoomCollectionViewCell.nib(), forCellWithReuseIdentifier: "ARRoomCollectionViewCell")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performSegue(withIdentifier: "goToPoppingMessage", sender: PoppingMessageVC.self)
        
    }
    
    func registerGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        let moveGestureLeft = UITapGestureRecognizer(target: self, action: #selector(leftArrowTouched))
        leftArrow.isUserInteractionEnabled = true
        leftArrow.addGestureRecognizer(moveGestureLeft)
        let moveGestureRight = UITapGestureRecognizer(target: self, action: #selector(rightArrowTouched))
        rightArrow.isUserInteractionEnabled = true
        rightArrow.addGestureRecognizer(moveGestureRight)
        let moveGestureUp = UITapGestureRecognizer(target: self, action: #selector(upArrowTouched))
        upArrow.isUserInteractionEnabled = true
        upArrow.addGestureRecognizer(moveGestureUp)
        let moveGestureDown = UITapGestureRecognizer(target: self, action: #selector(downArrowTouched))
        downArrow.isUserInteractionEnabled = true
        downArrow.addGestureRecognizer(moveGestureDown)
        
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(rotate))
        longPressGestureRecognizer.minimumPressDuration = 0.1
        self.sceneView.addGestureRecognizer(longPressGestureRecognizer)
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    @objc func rotate(sender: UILongPressGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let holdlocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(holdlocation)
        if !hitTest.isEmpty {
            
            let result = hitTest.first!
            if sender.state == .began {
                let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 1)
                let forever = SCNAction.repeatForever(rotation)
                result.node.runAction(forever)
                print("holding...")
            }else if sender.state == .ended{
                result.node.removeAllActions()
                print("released finger")
            }
        }
        
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty{
            addItem(hitTestResult: hitTest.first!)
            print("touched horizontal")
        }else{
            print("no match")
        }
    }
    
    @objc func leftArrowTouched(moveGestureLeft: UITapGestureRecognizer) {
        moveX = moveX - 0.1
        let tappedImageLeft = moveGestureLeft.view as! UIImageView
        let newPosition = nodePosition
        node.position = SCNVector3(x: (nodePosition.x) + Float(moveX) , y: nodePosition.y, z: (nodePosition.z) + Float(moveZ))
        sceneView.scene.rootNode.addChildNode(node)
        print(moveX)
        print(moveZ)
        print(newPosition)
    }
    
    @objc func rightArrowTouched(moveGestureRight: UITapGestureRecognizer) {
        moveX = moveX + 0.1
        let tappedImageRight = moveGestureRight.view as! UIImageView
        let newPosition = nodePosition
        node.position = SCNVector3(x: (nodePosition.x) + Float(moveX) , y: nodePosition.y, z: (nodePosition.z) + Float(moveZ))
        sceneView.scene.rootNode.addChildNode(node)
        print(moveX)
        print(moveZ)
        print(newPosition)
    }
    
    @objc func upArrowTouched(moveGestureUp: UITapGestureRecognizer) {
        moveZ = moveZ - 0.1
        let tappedImageUp = moveGestureUp.view as! UIImageView
        let newPosition = nodePosition
        node.position = SCNVector3(x: (nodePosition.x) + Float(moveX) , y: nodePosition.y, z: (nodePosition.z) + Float(moveZ))
        sceneView.scene.rootNode.addChildNode(node)
        print(moveX)
        print(moveZ)
        print(newPosition)
    }
    
    @objc func downArrowTouched(moveGestureDown: UITapGestureRecognizer) {
        moveZ = moveZ + 0.1
        let tappedImageDown = moveGestureDown.view as! UIImageView
        let newPosition = nodePosition
        node.position = SCNVector3(x: (nodePosition.x) + Float(moveX) , y: nodePosition.y, z: (nodePosition.z) + Float(moveZ))
        sceneView.scene.rootNode.addChildNode(node)
        print(moveX)
        print(moveZ)
        print(newPosition)
    }
    
    func addItem(hitTestResult: ARHitTestResult) {
        if let selectedItem = selectedItem {
            let scene = SCNScene (named: "art.scnassets/\(selectedItem).scn")
            node = (scene?.rootNode.childNode(withName: selectedItem, recursively: false))!
            let transform = hitTestResult.worldTransform
            let thirdColumn = transform.columns.3
            node.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
            nodePosition = transform.position()
            sceneView.scene.rootNode.addChildNode(node)
            
//            node.pivot = SCNMatrix4MakeTranslation(13.4, 12.9, 28.9)
            
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        let planeAnchor = anchor as! ARPlaneAnchor
        let plane = SCNPlane (width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        let planeNode = SCNNode()
        planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = ARRoomCollectionView.cellForItem(at: indexPath)
        selectedItem = imageToPass[indexPath.row]
        cell?.backgroundColor = #colorLiteral(red: 0.8517524004, green: 0.7229307294, blue: 0.5464949012, alpha: 1)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = ARRoomCollectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = #colorLiteral(red: 0.9928407073, green: 0.9410806298, blue: 0.8139055371, alpha: 1)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageToPass.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ARRoomCollectionViewCell", for: indexPath) as! ARRoomCollectionViewCell
        
        cell.configure(imageCell: UIImage(named: imageToPass[indexPath.row])!)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { return CGSize(width: 120, height: 120)
        
    }
    
    
    @IBAction func takePic(_ sender: UIBarButtonItem) {
        
        let snapShot = self.sceneView.snapshot()
        
        UIImageWriteToSavedPhotosAlbum(snapShot, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved!", message: "your photo saved in Albums", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            print("Error Saving ARKit Scene \(error)")
        } else {
            print("ARKit Scene Successfully Saved")
        }
    }
    
}



extension Int {
    var degreesToRadians: Double {return Double (self) * .pi / 180}
}

extension matrix_float4x4 {
    func position() -> SCNVector3 {
        return SCNVector3(columns.3.x, columns.3.y, columns.3.z)
    }
}

