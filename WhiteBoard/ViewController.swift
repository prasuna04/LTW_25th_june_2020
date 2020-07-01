//  ViewController.swift
//  AMDrawingView Demo
//  Created by Steve Landey on 7/23/18.
//  Copyright © 2018 Asana. All rights reserved.

import UIKit
import QuickLook
//import Quickblox
//import QuickbloxWebRTC
//import Drawsana   [ Commented this line By Ranjeet Raushan to generate the build ]
import MobileCoreServices

/**
 Bare-bones demonstration of the Drawsana API. Drawsana does not provide its
 own UI, so this demo has a very simple one.
 */

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  struct Constants {
    static let colors: [UIColor?] = [
      .black,
      .white,
      .red,
      .orange,
      .yellow,
      .green,
      .blue,
      .purple,
      .brown,
      .gray,
      .lightGray,
      nil
    ]
  }
  lazy var drawingView: DrawsanaView = {
    let drawingView = DrawsanaView()
    drawingView.delegate = self
    drawingView.operationStack.delegate = self
    return drawingView
  }()

  lazy var viewFinalImageButton = { return UIBarButtonItem(
    title: "Done",
    style: .plain,
    target: self,
    action: #selector(ViewController.viewFinalImage(_:)))
  }()
  let toolButton = UIButton(type: .custom)
//  let imageView = UIImageView(image: UIImage(named: "demo"))
    let imageView = UIImageView(image: UIImage(named: ""))

//  let undoButton = UIButton()
//  let redoButton = UIButton()
  let strokeColorButton = UIButton()
//  let fillColorButton = UIButton()
//  let strokeWidthButton = UIButton()
  let reloadButton = UIButton()
    
    //prasuna add this
    let moreButton = UIButton()
    let penButton = UIButton()
    let shapeButton = UIButton()
    let textButton = UIButton()
    let eraserButton = UIButton()
    let fillColorButton = UIButton()
    let strokeWidthButton = UIButton()
    let addImgButton = UIButton()
    let screenShotButton = UIButton()
    let zoomButton = UIButton()
    let undoButton = UIButton()
    let redoButton = UIButton()
    var imagePicker = ImagePicker()
    var subview = UIView()
    var scrollVW = UIScrollView()

    
    var  selectVal = 0
      // var session: QBRTCConferenceSession?
       private var images: [String] = []
     //  private weak var capture: QBRTCVideoCapture?
     //  private var enabled = false
      // private var screenCapture: ScreenCapture?
    
    lazy var toolbarStackView = {
        return UIStackView(arrangedSubviews: [
            moreButton,
            penButton,
            toolButton ,
            textButton,
            eraserButton ,
            fillColorButton ,
            strokeWidthButton ,
            addImgButton,
            screenShotButton,
            undoButton,
            redoButton,
        ])
    }()

  /// Instance of `TextTool` for which we are the delegate, so we can respond
  /// to relevant UI events
  lazy var textTool = { return TextTool(delegate: self) }()

  /// Instance of `SelectionTool` for which we are the delegate, so we can
  /// respond to relevant UI events
  lazy var selectionTool = { return SelectionTool(delegate: self) }()

    lazy var tools: [DrawingTool] = { return [
       selectionTool,
       EllipseTool(),
       LineTool(),
       ArrowTool(),
       RectTool(),
       StarTool(),
       TriangleTool(),
       PentagonTool(),
       AngleTool(),
     ] }()
    
    

  let strokeWidths: [CGFloat] = [1,2,3,4,5,6,7,8,9,10,12,14,16,18,20,30,40,50]
   
  var strokeWidthIndex = 5
    //prasuna added this om 8/6/2020
      weak var Delegate : EditImgSender?
      var delegate: VideoServiceDelegate?
    
    

  // Just AutoLayout code here
  override func loadView() {
    
    self.view = UIView()
    self.view.backgroundColor = .white
    scrollVW = UIScrollView.init(frame: CGRect.init(x: 10, y: 10, width: UIScreen.main.bounds.size.width - 10, height: 55))
    scrollVW.showsHorizontalScrollIndicator = false
    subview = UIView()
    
//    subview = UIView.init(frame: CGRect.init(x: 10, y: 10, width: self.view.frame.size.width - 20, height: 60))
//    subview.backgroundColor = .green
    
    toolButton.translatesAutoresizingMaskIntoConstraints = false
//    toolButton.setTitle("No Tool", for: .normal)
    toolButton.setImage(UIImage(named: "shape"), for: .normal)
    toolButton.addTarget(self, action: #selector(openToolMenu(_:)), for: .touchUpInside)
    toolButton.setContentHuggingPriority(.required, for: .vertical)

    undoButton.translatesAutoresizingMaskIntoConstraints = false
    undoButton.setImage(UIImage(named: "undo"), for: .normal)
//    undoButton.setTitle("←", for: .normal)
    undoButton.addTarget(drawingView.operationStack, action: #selector(DrawingOperationStack.undo), for: .touchUpInside)

    redoButton.translatesAutoresizingMaskIntoConstraints = false
    redoButton.setImage(UIImage(named: "redo"), for: .normal)
//    redoButton.setTitle("→", for: .normal)
    redoButton.addTarget(drawingView.operationStack, action: #selector(DrawingOperationStack.redo), for: .touchUpInside)

    strokeColorButton.translatesAutoresizingMaskIntoConstraints = false
    strokeColorButton.addTarget(self, action: #selector(ViewController.openStrokeColorMenu(_:)), for: .touchUpInside)
    strokeColorButton.setImage(UIImage(named: "color"), for: .normal)

//    strokeColorButton.layer.borderColor = UIColor.white.cgColor
//    strokeColorButton.layer.borderWidth = 0.5

    fillColorButton.translatesAutoresizingMaskIntoConstraints = false
    fillColorButton.addTarget(self, action: #selector(ViewController.openFillColorMenu(_:)), for: .touchUpInside)
    fillColorButton.setImage(UIImage(named: "color"), for: .normal)

//    fillColorButton.layer.borderColor = UIColor.white.cgColor
//    fillColorButton.layer.borderWidth = 0.5

    strokeWidthButton.setImage(UIImage(named: "line-tickness"), for: .normal)
    strokeWidthButton.translatesAutoresizingMaskIntoConstraints = false
    strokeWidthButton.addTarget(self, action: #selector(openPencilSizeToolMenu(_:)), for: .touchUpInside)
//    strokeWidthButton.layer.borderColor = UIColor.white.cgColor
//    strokeWidthButton.layer.borderWidth = 0.5

    reloadButton.translatesAutoresizingMaskIntoConstraints = false
    reloadButton.addTarget(self, action: #selector(ViewController.reload(_:)), for: .touchUpInside)
//    reloadButton.layer.borderColor = UIColor.white.cgColor
//    reloadButton.layer.borderWidth = 0.5
    reloadButton.setTitle("🔁", for: .normal)
    
  
    //prasuna add this
    
       moreButton.translatesAutoresizingMaskIntoConstraints = false
       moreButton.setImage(UIImage(named: "move"), for: .normal)
       moreButton.addTarget(self, action: #selector(ViewController.reload(_:)), for: .touchUpInside)
    
    penButton.translatesAutoresizingMaskIntoConstraints = false
    penButton.setImage(UIImage(named: "edit-selected"), for: .normal)
//    penButton.setTitle("Pen", for: .normal)
    penButton.tag = 1
    penButton.addTarget(self, action: #selector(selectTools(tool:)), for: .touchUpInside)
    
    textButton.translatesAutoresizingMaskIntoConstraints = false
    textButton.setImage(UIImage(named: "text"), for: .normal)
    textButton.tag = 2
    textButton.addTarget(self, action: #selector(selectTools(tool:)), for: .touchUpInside)
    
    eraserButton.translatesAutoresizingMaskIntoConstraints = false
    eraserButton.setImage(UIImage(named: "eraser"), for: .normal)
    eraserButton.tag = 3
    eraserButton.addTarget(self, action: #selector(selectTools(tool:)), for: .touchUpInside)
    
    
    addImgButton.translatesAutoresizingMaskIntoConstraints = false
    addImgButton.setImage(UIImage(named: "add-picture"), for: .normal)
    addImgButton.addTarget(self, action: #selector(tappedMe), for: .touchUpInside)
    
    screenShotButton.translatesAutoresizingMaskIntoConstraints = false
    screenShotButton.setImage(UIImage(named: "screenshot"), for: .normal)
    screenShotButton.addTarget(self, action: #selector(ViewController.reload(_:)), for: .touchUpInside)
   
//    zoomButton.translatesAutoresizingMaskIntoConstraints = false
//    zoomButton.setImage(UIImage(named: "move"), for: .normal)
//    zoomButton.addTarget(self, action: #selector(ViewController.reload(_:)), for: .touchUpInside)
    subview.translatesAutoresizingMaskIntoConstraints = false
    toolbarStackView.translatesAutoresizingMaskIntoConstraints = false
    toolbarStackView.axis = .horizontal
    toolbarStackView.distribution = .fillEqually
    toolbarStackView.alignment = .fill
//    subview.layer.cornerRadius = subview.frame.height/2
//    subview.layer.borderWidth = 1
//    subview.layer.borderColor = UIColor.lightGray.cgColor
//    view.addSubview(toolbarStackView)
//    view.addSubview(subview)
    
    scrollVW.addSubview(subview)
    subview.addSubview(toolbarStackView)
    view.addSubview(scrollVW)
    view.bringSubviewToFront(toolbarStackView)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
//    imageView.backgroundColor = .white
    view.addSubview(imageView)

    drawingView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(drawingView)

//    let imageAspectRatio = imageView.image!.size.width / imageView.image!.size.height

    let noOfButtons = 11
    var imgesWidth = CGFloat(noOfButtons * (30 + 20))
    if UIDevice.current.userInterfaceIdiom == .pad || imgesWidth > imgesWidth
    {
        imgesWidth = UIScreen.main.bounds.size.width
    }
    scrollVW.contentSize = CGSize(width: imgesWidth, height: 55)
    
    NSLayoutConstraint.activate([
        
        // toolbarStackView fill bottom
        
          scrollVW.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
                scrollVW.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5),
                scrollVW.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -5),
                scrollVW.heightAnchor.constraint(equalToConstant: 55),
        //        scrollVW.widthAnchor.constraint(equalToConstant: imgesWidth),
               
                subview.topAnchor.constraint(equalTo: scrollVW.topAnchor, constant: 1),
                subview.leftAnchor.constraint(equalTo: scrollVW.leftAnchor, constant:5 ),
                subview.widthAnchor.constraint(equalToConstant: imgesWidth),
                subview.rightAnchor.constraint(equalTo: scrollVW.rightAnchor, constant: -5),
                subview.bottomAnchor.constraint(equalTo: scrollVW.bottomAnchor, constant: 0),
                
                toolbarStackView.topAnchor.constraint(equalTo: subview.topAnchor, constant: 1),
                toolbarStackView.leftAnchor.constraint(equalTo: subview.leftAnchor, constant: 10),
                toolbarStackView.rightAnchor.constraint(equalTo: subview.rightAnchor, constant: -1),
                toolbarStackView.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: 0),
//        subview.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
//        subview.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
//        subview.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
//        subview.heightAnchor.constraint(equalToConstant: 60),
//        toolbarStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
//        toolbarStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
//        toolbarStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
//        toolbarStackView.heightAnchor.constraint(equalToConstant: 60),
      // imageView constrain to left/top/right
      imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
      imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
      imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
      imageView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
      imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

//      imageView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 100),
      

      // tool button constant width
      toolButton.widthAnchor.constraint(equalToConstant: 90),

      // imageView bottom -> toolbarStackView.top
//      drawingView.topAnchor.constraint(equalTo: toolbarStackView.bottomAnchor),
      drawingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),

//       drawingView is centered in imageView, shares image's aspect ratio,
//       and doesn't expand past its frame
      drawingView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
      drawingView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
      drawingView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
//      drawingView.heightAnchor.constraint(equalTo: imageView.heightAnchor),
      drawingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      // Color buttons have constant size
      strokeColorButton.widthAnchor.constraint(equalToConstant: 30),
      strokeColorButton.heightAnchor.constraint(equalToConstant: 30),
      fillColorButton.widthAnchor.constraint(equalToConstant: 30),
      fillColorButton.heightAnchor.constraint(equalToConstant: 30),
    ])
  }

  override func viewDidLoad() {
    
    super.viewDidLoad()
    // Better error reporting in dev
    Drawing.debugSerialization = true
    
    /* Added By Prasuna on 16th April 2020 - starts here */
//    viewFinalImageButton.tintColor = UIColor.init(hex:"2DA9EC" )
//    viewFinalImageButton.tintColor = UIColor.white
    /* Added By Prasuna on 16th April 2020 - ends  here */
    
    navigationItem.rightBarButtonItem = viewFinalImageButton
    // Set initial tool to whatever `toolIndex` says
    drawingView.set(tool:PenTool())
    drawingView.userSettings.strokeColor = Constants.colors.first!
    drawingView.userSettings.fillColor = Constants.colors.last!
    drawingView.userSettings.strokeWidth = strokeWidths[strokeWidthIndex]
    drawingView.userSettings.fontName = "Marker Felt"
    applyUndoViewState()
    
//    if let session = session {
//
//               enabled = session.localMediaStream.videoTrack.isEnabled
//               capture = session.localMediaStream.videoTrack.videoCapture
//               screenCapture = ScreenCapture(view: view)
//               //Switch to sharing
//               session.localMediaStream.videoTrack.videoCapture = screenCapture
//           }
  }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navigationController = navigationController else { return }
        navigationController.view.backgroundColor = .white
        if (self.navigationController?.navigationBar) != nil {
            navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           
//           if let session = session,
//               enabled == false {
//               session.localMediaStream.videoTrack.isEnabled = true
//           }
       }
       
    override func viewWillDisappear(_ animated: Bool) {
               
//      dismiss(animated: true, completion: nil)

    }
    
       override func viewDidDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           guard let navigationController = navigationController else { return }
           navigationController.view.backgroundColor = UIColor.init(hex:"2DA9EC")
           if (self.navigationController?.navigationBar) != nil {
               navigationController.navigationBar.barTintColor = UIColor.init(hex: "2DA9EC")
           }
//           if isMovingFromParent == true,
//               enabled == false,
//               let session = session {
//               session.localMediaStream.videoTrack.isEnabled = false
//               session.localMediaStream.videoTrack.videoCapture = capture
//           }
       }
    
    
       // Profile Image related
     @objc func tappedMe(){
         let alert = UIAlertController(title: "Select Photo", message: "", preferredStyle: .actionSheet)
         alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
             //execute some code when this option is selected
             if UIImagePickerController.isSourceTypeAvailable(.camera) {
                 let picker = UIImagePickerController()
                 picker.delegate = self
                 picker.allowsEditing = true
                 picker.sourceType = UIImagePickerController.SourceType.camera
                 picker.cameraCaptureMode = .photo
                 picker.modalPresentationStyle = .fullScreen
                 picker.delegate = self
                 picker.navigationBar.topItem?.rightBarButtonItem?.tintColor = .black
                 self.present(picker,animated: true,completion: nil)
             }else{
                 self.noCamera()
             }
         }))
         alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action) in
             let picker = UIImagePickerController()
             picker.delegate = self
             picker.allowsEditing = false
             picker.sourceType = .savedPhotosAlbum
             picker.mediaTypes = [kUTTypeImage as String]
             picker.navigationBar.isTranslucent = false
             picker.navigationBar.barTintColor = UIColor.init(hex:"2DA9EC") // Background color
             picker.navigationBar.tintColor = .white // Cancel button ~ any UITabBarButton items
             picker.navigationBar.titleTextAttributes = [
                 NSAttributedString.Key.foregroundColor : UIColor.white
             ]
             
             self.present(picker, animated: true, completion: nil)
         }))
         alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
             //execute some code when this option is selected
             self.dismiss(animated: true, completion: nil)
             
         }))
         
         // below 3 lines are for iPAD
         alert.popoverPresentationController?.sourceView = self.view
         alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
         alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
         self.present(alert, animated: true, completion: nil)
         
     }
     
    // Profile Image related
     @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         // The info dictionary may contain multiple representations of the image. You can use the original.
         guard let chosenImage = info[.originalImage] as? UIImage else {
             fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
         }
         imageView.image = chosenImage
         let imageFolder = imagePicker.getImagesFolder()
         let uniqueFileName = imagePicker.getUniqueFileName()
         let finalPath = URL.init(fileURLWithPath: "\(String(describing: imageFolder))/\(String(describing: uniqueFileName))")
         do {
             
             try chosenImage.jpegData(compressionQuality: 1)?.write(to: finalPath, options: .atomic)
         }
         catch {
             let fetchError = error as NSError
             print(fetchError)
         }
         dismiss(animated:true, completion: nil)
     }
     func noCamera(){
         let alertVC = UIAlertController(
             title: "No Camera",
             message: "Sorry, this device has no camera",
             preferredStyle: .alert)
         let okAction = UIAlertAction(
             title: "OK",
             style:.default,
             handler: nil)
         alertVC.addAction(okAction)
         present(
             alertVC,
             animated: true,
             completion: nil)
     }

    
    
  var savedImageURL: URL {
    return FileManager.default.temporaryDirectory.appendingPathComponent("drawsana_demo").appendingPathExtension("jpg")
  }
    
    @objc func selectTools(tool: UIButton) {
        
        
        switch tool.tag {
        case 1:
            drawingView.set(tool: PenTool())//pen
        case 2:
         drawingView.set(tool:textTool)//text
        case 3:
        drawingView.set(tool:EraserTool())//eraser
       
        default:
            drawingView.set(tool: PenTool())

        }
        
      dismiss(animated: true, completion: nil)
    }

  /// Show rendered image in a separate view
    @objc private func viewFinalImage(_ sender: Any?) {
      
      // Dump JSON to console just to demonstrate
      let jsonEncoder = JSONEncoder()
      jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
      let jsonData = try! jsonEncoder.encode(drawingView.drawing)
      print(String(data: jsonData, encoding: .utf8)!)

      // Decode as a sanity check in lieu of unit tests
      let jsonDecoder = JSONDecoder()
      let _ = try! jsonDecoder.decode(Drawing.self, from: jsonData)
      let filePath = "\(AppConstants().getImagesFolder())"
      let filename = "\(AppConstants().getUniqueFileName())"
      let Imagetimestamp = "IMG\(AppConstants().getUniqueFileName())"
      let fileUrl = URL.init(fileURLWithPath: "\(filePath)/\(filename)")

      guard
        let image = drawingView.render(over: imageView.image),
        let data = image.jpegData(compressionQuality: 0.75),
        (try? data.write(to: fileUrl)) != nil else
      {
        assert(false, "Can't create or save image")
        return
      }
      var mediaObjDict: [String : Any] = [:]

         
              mediaObjDict["fileName"] = fileUrl.lastPathComponent
              mediaObjDict["filePath"] = "\(fileUrl)"
         
      
          
      self.delegate?.imagePickerdidfinishLoaded(withData: mediaObjDict, and: Imagetimestamp)
      Delegate?.getImg(EditedImg: image)
      _ = navigationController?.popViewController(animated: true)
      
  //    let vc = QLPreviewController(nibName: nil, bundle: nil)
  //    vc.dataSource = self
  //    present(vc, animated: true, completion: nil)
      
    }

  private func presentPopover(_ viewController: UIViewController, sourceView: UIView) {
    viewController.modalPresentationStyle = .popover
    viewController.popoverPresentationController!.sourceView = sourceView
    viewController.popoverPresentationController!.sourceRect = sourceView.bounds
    viewController.popoverPresentationController!.delegate = self
    present(viewController, animated: true, completion: nil)
  }

  @objc private func openStrokeColorMenu(_ sender: UIView) {
    presentPopover(
      ColorPickerViewController(identifier: "stroke", colors: Constants.colors, delegate: self),
      sourceView: sender)
  }

  @objc private func openFillColorMenu(_ sender: UIView) {
    presentPopover(
      ColorPickerViewController(identifier: "fill", colors: Constants.colors, delegate: self),
      sourceView: sender)
  }

  @objc private func openToolMenu(_ sender: UIView) {
    presentPopover(
      ToolPickerViewController(tools: tools, delegate: self),
      sourceView: sender)
  }
    @objc private func openPencilSizeToolMenu(_ sender: UIView) {
       presentPopover(
         PencilSizePickerViewController(tools: strokeWidths, delegate: self),
         sourceView: sender)
     }
    

  @objc private func cycleStrokeWidth(_ sender: Any?) {
    strokeWidthIndex = (strokeWidthIndex + 1) % strokeWidths.count
    drawingView.userSettings.strokeWidth = strokeWidths[strokeWidthIndex]
  }

  @objc private func reload(_ sender: Any?) {
    print("Serializing/deserializing...")
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let jsonData = try! encoder.encode(drawingView.drawing)
    print(String(data: jsonData, encoding: .utf8)!)
    drawingView.drawing = try! JSONDecoder().decode(
      Drawing.self,
      from: jsonData)
    print(drawingView.drawing.shapes)
    print("Done")
  }

  /// Update button states to reflect undo stack
  private func applyUndoViewState() {
    undoButton.isEnabled = drawingView.operationStack.canUndo
    redoButton.isEnabled = drawingView.operationStack.canRedo

    for button in [undoButton, redoButton] {
      button.alpha = button.isEnabled ? 1 : 0.5
    }
  }
}

extension ViewController: ColorPickerViewControllerDelegate {
  func colorPickerViewControllerDidPick(colorIndex: Int, color: UIColor?, identifier: String) {
    switch identifier {
    case "stroke":
      drawingView.userSettings.strokeColor = color
    case "fill":
        drawingView.userSettings.strokeColor = color

//      drawingView.userSettings.fillColor = color
    default: break;
    }
    dismiss(animated: true, completion: nil)
  }
}

extension ViewController: ToolPickerViewControllerDelegate {
    
     func toolPickerViewControllerDidPick(tool: DrawingTool) {
    drawingView.set(tool: tool)
    dismiss(animated: true, completion: nil)
  }
     
}

extension ViewController: PenSizePickerViewControllerDelegate{
    
    func toolPickerViewControllerDidPickTheWidthOfLine(width: CGFloat) {
        drawingView.userSettings.strokeWidth = width
        dismiss(animated: true, completion: nil)

    }
}

extension ViewController: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
}

extension ViewController: DrawsanaViewDelegate {
  /// When tool changes, update the UI
  func drawsanaView(_ drawsanaView: DrawsanaView, didSwitchTo tool: DrawingTool) {
//    toolButton.setTitle(drawingView.tool?.name ?? "", for: .normal)
  }

  func drawsanaView(_ drawsanaView: DrawsanaView, didChangeStrokeColor strokeColor: UIColor?) {
    strokeColorButton.backgroundColor = drawingView.userSettings.strokeColor
    strokeColorButton.setTitle(drawingView.userSettings.strokeColor == nil ? "x" : "", for: .normal)
  }

  func drawsanaView(_ drawsanaView: DrawsanaView, didChangeFillColor fillColor: UIColor?) {
    fillColorButton.backgroundColor = drawingView.userSettings.fillColor
    fillColorButton.setTitle(drawingView.userSettings.fillColor == nil ? "x" : "", for: .normal)
  }

  func drawsanaView(_ drawsanaView: DrawsanaView, didChangeStrokeWidth strokeWidth: CGFloat) {
    strokeWidthIndex = strokeWidths.firstIndex(of: drawingView.userSettings.strokeWidth) ?? 0
    strokeWidthButton.setTitle("\(Int(strokeWidths[strokeWidthIndex]))", for: .normal)
  }

  func drawsanaView(_ drawsanaView: DrawsanaView, didChangeFontName fontName: String) {
  }

  func drawsanaView(_ drawsanaView: DrawsanaView, didChangeFontSize fontSize: CGFloat) {
  }

  func drawsanaView(_ drawsanaView: DrawsanaView, didStartDragWith tool: DrawingTool) {
  }

  func drawsanaView(_ drawsanaView: DrawsanaView, didEndDragWith tool: DrawingTool) {
  }
}

extension ViewController: SelectionToolDelegate {
  /// When a shape is double-tapped by the selection tool, and it's text,
  /// begin editing the text
  func selectionToolDidTapOnAlreadySelectedShape(_ shape: ShapeSelectable) {
    if shape as? TextShape != nil {
      drawingView.set(tool: textTool, shape: shape)
    } else {
      drawingView.toolSettings.selectedShape = nil
    }
  }
}

extension ViewController: TextToolDelegate {
  /// Don't modify text point. In reality you probably do want to modify it to
  /// make sure it's not below the keyboard.
  func textToolPointForNewText(tappedPoint: CGPoint) -> CGPoint {
    return tappedPoint
  }

  /// When user taps away from text, switch to the selection tool so they can
  /// tap anything they want.
  func textToolDidTapAway(tappedPoint: CGPoint) {
    drawingView.set(tool: self.selectionTool)
  }

  func textToolWillUseEditingView(_ editingView: TextShapeEditingView) {
     let makeView: (UIImage?) -> UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.backgroundColor = .black
      view.layer.cornerRadius = 6
      view.layer.borderWidth = 1
      view.layer.borderColor = UIColor.white.cgColor
      view.layer.shadowColor = UIColor.black.cgColor
      view.layer.shadowOffset = CGSize(width: 1, height: 1)
      view.layer.shadowRadius = 3
      view.layer.shadowOpacity = 0.5
      if let image = $0 {
        view.frame = CGRect(origin: .zero, size: CGSize(width: 16, height: 16))
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.frame = view.bounds.insetBy(dx: 4, dy: 4)
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        view.addSubview(imageView)
      }
      return view
    }

    let buttonSize: CGFloat = 36
    let halfButtonSize = buttonSize / 2

    editingView.addControl(dragActionType: .delete, view: makeView(UIImage(named: "icon_delete"))) { (textView, deleteControlView) in
      deleteControlView.layer.anchorPoint = CGPoint(x: 1, y: 1)
      NSLayoutConstraint.activate([
        deleteControlView.widthAnchor.constraint(equalToConstant: buttonSize),
        deleteControlView.heightAnchor.constraint(equalToConstant: buttonSize),
        deleteControlView.rightAnchor.constraint(equalTo: textView.leftAnchor, constant: halfButtonSize),
        deleteControlView.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -3 + halfButtonSize),
      ])
    }

    editingView.addControl(dragActionType: .resizeAndRotate, view: makeView(UIImage(named: "icon_resize_rotate"))) { (textView, resizeAndRotateControlView) in
      resizeAndRotateControlView.layer.anchorPoint = CGPoint(x: 0, y: 0)
      NSLayoutConstraint.activate([
        resizeAndRotateControlView.widthAnchor.constraint(equalToConstant: buttonSize),
        resizeAndRotateControlView.heightAnchor.constraint(equalToConstant: buttonSize),
        resizeAndRotateControlView.leftAnchor.constraint(equalTo: textView.rightAnchor, constant: 5 - halfButtonSize),
        resizeAndRotateControlView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4 - halfButtonSize),
      ])
    }

    editingView.addControl(dragActionType: .changeWidth, view: makeView(UIImage(named: "icon_change_width"))) { (textView, changeWidthControlView) in
      changeWidthControlView.layer.anchorPoint = CGPoint(x: 0, y: 1)
      NSLayoutConstraint.activate([
        changeWidthControlView.widthAnchor.constraint(equalToConstant: buttonSize),
        changeWidthControlView.heightAnchor.constraint(equalToConstant: buttonSize),
        changeWidthControlView.leftAnchor.constraint(equalTo: textView.rightAnchor, constant: 5 - halfButtonSize),
        changeWidthControlView.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -4 + halfButtonSize),
      ])
    }
  }

  func textToolDidUpdateEditingViewTransform(_ editingView: TextShapeEditingView, transform: ShapeTransform) {
    for control in editingView.controls {
      control.view.transform = CGAffineTransform(scaleX: 1/transform.scale, y: 1/transform.scale)
    }
  }
}

/// Implement `DrawingOperationStackDelegate` to keep the UI in sync with the
/// operation stack
extension ViewController: DrawingOperationStackDelegate {
  func drawingOperationStackDidUndo(_ operationStack: DrawingOperationStack, operation: DrawingOperation) {
    applyUndoViewState()
  }

  func drawingOperationStackDidRedo(_ operationStack: DrawingOperationStack, operation: DrawingOperation) {
    applyUndoViewState()
  }

  func drawingOperationStackDidApply(_ operationStack: DrawingOperationStack, operation: DrawingOperation) {
    applyUndoViewState()
  }
}

extension ViewController: QLPreviewControllerDataSource {
  func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
    return 1
  }

  func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
    return savedImageURL as NSURL
  }
}

private extension NSLayoutConstraint {
  func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
    self.priority = priority
    return self
  }
}
