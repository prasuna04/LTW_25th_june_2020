//  InLineScribbleVC.swift
//  LTW
//  Created by vaayoo on 30/12/19.
//  Copyright © 2019 vaayoo. All rights reserved.


import UIKit
//import Drawsana
import QuickLook
import Mantis

protocol ScribbleImgSender : class {
    func getImg(scribbleImg : UIImage)
}


class InLineScribbleVC : UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAdaptivePresentationControllerDelegate, CropViewControllerDelegate {
    
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage) {
        backgroungImg.image = cropped
    }
    
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
      nil
    ]
  }

    weak var Delegate : ScribbleImgSender?
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
    action: #selector(InLineScribbleVC.viewFinalImage(_:)))
  }()
  let toolButton = UIButton(type: .custom)
  let backgroungImg = UIImageView()
  let undoButton = UIButton()
  let redoButton = UIButton()
  let strokeColorButton = UIButton()
  let fillColorButton = UIButton()
  let strokeWidthButton = UIButton()
  let reloadButton = UIButton()
    //
     let penButton = UIButton()
    let textButton = UIButton()
     let eraserButton = UIButton()
     let cropImageButton = UIButton()
     var subview = UIView()
    
    
  lazy var toolbarStackView = {
    return UIStackView(arrangedSubviews: [
        penButton,
        strokeColorButton,
        strokeWidthButton,
        eraserButton,
       // textButton,
        //cropImageButton,
        undoButton,
        redoButton,
     
      //fillColorButton,
     // reloadButton,
     // toolButton,
    ])
  }()

  /// Instance of `TextTool` for which we are the delegate, so we can respond
  /// to relevant UI events
  lazy var textTool = { return TextTool(delegate: self) }()

  /// Instance of `SelectionTool` for which we are the delegate, so we can
  /// respond to relevant UI events
  lazy var selectionTool = { return SelectionTool(delegate: self) }()

  lazy var tools: [DrawingTool] = { return [
    PenTool(),
    textTool,
//    selectionTool,
//    EllipseTool(),
    EraserTool(),
//    LineTool(),
//    ArrowTool(),
//    RectTool(),
//    StarTool(),
//    TriangleTool(),
//    PentagonTool(),
//    AngleTool(),
  ] }()

   let strokeWidths: [CGFloat] = [5,10,15,20,25]
  var strokeWidthIndex = 0

  // Just AutoLayout code here
  override func loadView() {
    self.view = UIView()
    self.view = UIView()
    self.view.backgroundColor = .white
    subview = UIView.init(frame: CGRect.init(x: 10, y: 10, width: self.view.frame.size.width - 20, height: 60))

    toolButton.translatesAutoresizingMaskIntoConstraints = false
    toolButton.setTitle("No Tool", for: .normal)
    toolButton.addTarget(self, action: #selector(openToolMenu(_:)), for: .touchUpInside)
    toolButton.setContentHuggingPriority(.required, for: .vertical)

    undoButton.translatesAutoresizingMaskIntoConstraints = false
     undoButton.setImage(UIImage(named: "undo"), for: .normal)
   // undoButton.setTitle("←", for: .normal)
    undoButton.addTarget(drawingView.operationStack, action: #selector(DrawingOperationStack.undo), for: .touchUpInside)

    redoButton.translatesAutoresizingMaskIntoConstraints = false
    redoButton.setImage(UIImage(named: "redo"), for: .normal)
   // redoButton.setTitle("→", for: .normal)
    redoButton.addTarget(drawingView.operationStack, action: #selector(DrawingOperationStack.redo), for: .touchUpInside)

    strokeColorButton.translatesAutoresizingMaskIntoConstraints = false
    strokeColorButton.addTarget(self, action: #selector(InLineScribbleVC.openStrokeColorMenu(_:)), for: .touchUpInside)
    strokeColorButton.setImage(UIImage(named: "color"), for: .normal)
//    strokeColorButton.layer.borderColor = UIColor.white.cgColor
//    strokeColorButton.layer.borderWidth = 0.5

    fillColorButton.translatesAutoresizingMaskIntoConstraints = false
    fillColorButton.addTarget(self, action: #selector(InLineScribbleVC.openFillColorMenu(_:)), for: .touchUpInside)
    fillColorButton.layer.borderColor = UIColor.white.cgColor
    fillColorButton.layer.borderWidth = 0.5

    strokeWidthButton.setImage(UIImage(named: "line-tickness"), for: .normal)
    strokeWidthButton.translatesAutoresizingMaskIntoConstraints = false
    strokeWidthButton.addTarget(self, action: #selector(openPencilSizeToolMenu(_:)), for: .touchUpInside)
//    strokeWidthButton.layer.borderColor = UIColor.white.cgColor
//    strokeWidthButton.layer.borderWidth = 0.5

    reloadButton.translatesAutoresizingMaskIntoConstraints = false
    reloadButton.addTarget(self, action: #selector(InLineScribbleVC.reload(_:)), for: .touchUpInside)
    reloadButton.layer.borderColor = UIColor.white.cgColor
    reloadButton.layer.borderWidth = 0.5
    reloadButton.setTitle("🔁", for: .normal)
    
    /////////////////
     penButton.translatesAutoresizingMaskIntoConstraints = false
        penButton.setImage(UIImage(named: "edit-selected"), for: .normal)
    //    penButton.setTitle("Pen", for: .normal)
        penButton.tag = 1
        penButton.addTarget(self, action: #selector(selectTools(tool:)), for: .touchUpInside)
    
    cropImageButton.translatesAutoresizingMaskIntoConstraints = false
    cropImageButton.setImage(UIImage(named: "screenshot"), for: .normal)
    cropImageButton.addTarget(self, action: #selector(cropImg(_:)), for: .touchUpInside)
    
    textButton.translatesAutoresizingMaskIntoConstraints = false
      textButton.setImage(UIImage(named: "text"), for: .normal)
      textButton.tag = 2
      textButton.addTarget(self, action: #selector(selectTools(tool:)), for: .touchUpInside)
      
      eraserButton.translatesAutoresizingMaskIntoConstraints = false
      eraserButton.setImage(UIImage(named: "eraser"), for: .normal)
      eraserButton.tag = 3
      eraserButton.addTarget(self, action: #selector(selectTools(tool:)), for: .touchUpInside)
    subview.translatesAutoresizingMaskIntoConstraints = false
       toolbarStackView.translatesAutoresizingMaskIntoConstraints = false
       toolbarStackView.axis = .horizontal
       toolbarStackView.distribution = .fillEqually
       toolbarStackView.alignment = .fill
       subview.layer.cornerRadius = subview.frame.height/2
       subview.layer.borderWidth = 1
       subview.layer.borderColor = UIColor.lightGray.cgColor
       view.addSubview(toolbarStackView)
       view.addSubview(subview)
       view.bringSubviewToFront(toolbarStackView)
    
    backgroungImg.translatesAutoresizingMaskIntoConstraints = false
    backgroungImg.contentMode = .scaleAspectFit
    backgroungImg.backgroundColor = .gray
    view.addSubview(backgroungImg)

    drawingView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(drawingView)

    let imageAspectRatio = backgroungImg.image!.size.width / backgroungImg.image!.size.height

    NSLayoutConstraint.activate([
      // imageView constrain to left/top/right
      backgroungImg.leftAnchor.constraint(equalTo: view.leftAnchor),
      backgroungImg.rightAnchor.constraint(equalTo: view.rightAnchor),
      backgroungImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

      // toolbarStackView fill bottom
      toolbarStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      toolbarStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
      toolbarStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),

      // tool button constant width
      toolButton.widthAnchor.constraint(equalToConstant: 90),

      // imageView bottom -> toolbarStackView.top
      backgroungImg.bottomAnchor.constraint(equalTo: toolbarStackView.topAnchor),

      // drawingView is centered in imageView, shares image's aspect ratio,
      // and doesn't expand past its frame
      drawingView.centerXAnchor.constraint(equalTo: backgroungImg.centerXAnchor),
      drawingView.centerYAnchor.constraint(equalTo: backgroungImg.centerYAnchor),
      drawingView.widthAnchor.constraint(lessThanOrEqualTo: backgroungImg.widthAnchor),
      drawingView.heightAnchor.constraint(lessThanOrEqualTo: backgroungImg.heightAnchor),
      drawingView.widthAnchor.constraint(equalTo: drawingView.heightAnchor, multiplier: imageAspectRatio),
      drawingView.widthAnchor.constraint(equalTo: backgroungImg.widthAnchor).withPriority(.defaultLow),
      drawingView.heightAnchor.constraint(equalTo: backgroungImg.heightAnchor).withPriority(.defaultLow),

      // Color buttons have constant size
      strokeColorButton.widthAnchor.constraint(equalToConstant: 30),
      strokeColorButton.heightAnchor.constraint(equalToConstant: 30),
      fillColorButton.widthAnchor.constraint(equalToConstant: 30),
      fillColorButton.heightAnchor.constraint(equalToConstant: 30),
    ])
  }

    override func viewDidLoad() {
    super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
    // Better error reporting in dev
    Drawing.debugSerialization = true

    navigationItem.rightBarButtonItem = viewFinalImageButton

    // Set initial tool to whatever `toolIndex` says
    drawingView.set(tool: tools[0])
    drawingView.userSettings.strokeColor = Constants.colors.first!
    drawingView.userSettings.fillColor = Constants.colors.last!
    drawingView.userSettings.strokeWidth = strokeWidths[strokeWidthIndex]
    drawingView.userSettings.fontName = "Marker Felt"
    applyUndoViewState()
    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.init(hex: "2DA9EC")]
           navigationController?.navigationBar.titleTextAttributes = textAttributes
          // navigationItem.title = "ANSWER"
           if (self.navigationController?.navigationBar) != nil {
            self.navigationController!.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.init(hex: "2DA9EC")
            self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = UIColor.init(hex: "2DA9EC")
            //self.navigationController!.navigationBar.topItem?.leftBarButtonItem?.tintColor = UIColor.init(hex: "2DA9EC")
            if let gesutreRecognize = self.navigationController?.navigationBar.gestureRecognizers { for gesture in gesutreRecognize where gesture is UISwipeGestureRecognizer { gesture.isEnabled = false } }
    }
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
           
        // dismiss(animated: true, completion: nil)
       }
    
    
    
    
    
    
    
    
    

  var savedImageURL: URL {
    return FileManager.default.temporaryDirectory.appendingPathComponent("drawsana_demo").appendingPathExtension("jpg")
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
   // KeyViewController.scribbledImg = drawingView.render(over: backgroungImg.image)!
    let image = drawingView.render(over: backgroungImg.image)!
    Delegate?.getImg(scribbleImg: image)
    _ = navigationController?.popViewController(animated: true)
    dismiss(animated: true, completion: nil)
    self.dismiss(animated: true, completion: nil )
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

    @objc private func cropImg(_ sender: Any){
        let config = Mantis.Config()
        let jsonEncoder = JSONEncoder()
           jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
           let jsonData = try! jsonEncoder.encode(drawingView.drawing)
           print(String(data: jsonData, encoding: .utf8)!)

           // Decode as a sanity check in lieu of unit tests
         let jsonDecoder = JSONDecoder()
           let _ = try! jsonDecoder.decode(Drawing.self, from: jsonData)
           let image = drawingView.render(over: backgroungImg.image)!
        let cropViewController = Mantis.cropViewController(image: image , config: config)
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
  @objc private func openFillColorMenu(_ sender: UIView) {
    presentPopover(
      ColorPickerViewController(identifier: "fill", colors: Constants.colors, delegate: self),
      sourceView: sender)
  }
    @objc private func openPencilSizeToolMenu(_ sender: UIView) {
          presentPopover(
            PencilSizePickerViewController(tools: strokeWidths, delegate: self),
            sourceView: sender)
        }
  @objc private func openToolMenu(_ sender: UIView) {
    presentPopover(
      ToolPickerViewController(tools: tools, delegate: self),
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

extension InLineScribbleVC: ColorPickerViewControllerDelegate {
  func colorPickerViewControllerDidPick(colorIndex: Int, color: UIColor?, identifier: String) {
    switch identifier {
    case "stroke":
      drawingView.userSettings.strokeColor = color
    case "fill":
      drawingView.userSettings.fillColor = color
    default: break;
    }
    dismiss(animated: true, completion: nil)
  }
}

extension InLineScribbleVC: ToolPickerViewControllerDelegate {
  func toolPickerViewControllerDidPick(tool: DrawingTool) {
    drawingView.set(tool: tool)
    dismiss(animated: true, completion: nil)
  }
}

extension InLineScribbleVC: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
}

extension InLineScribbleVC: DrawsanaViewDelegate {
  /// When tool changes, update the UI
  func drawsanaView(_ drawsanaView: DrawsanaView, didSwitchTo tool: DrawingTool) {
    toolButton.setTitle(drawingView.tool?.name ?? "", for: .normal)
  }

  func drawsanaView(_ drawsanaView: DrawsanaView, didChangeStrokeColor strokeColor: UIColor?) {
   // strokeColorButton.backgroundColor = drawingView.userSettings.strokeColor
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

extension InLineScribbleVC: SelectionToolDelegate {
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

extension InLineScribbleVC: TextToolDelegate {
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
    // This example implementation of `textToolWillUseEditingView` shows how you
    // can customize the appearance of the text tool
    //
    // Important note: each handle's layer.anchorPoint is set to a non-0.5,0.5
    // value, so the positions are offset from where AutoLayout puts them.
    // That's why `halfButtonSize` is added and subtracted depending on which
    // control is being configured.
    //
    // The anchor point is changed so that the controls can be scaled correctly
    // in `textToolDidUpdateEditingViewTransform`.

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
extension InLineScribbleVC: DrawingOperationStackDelegate {
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

extension InLineScribbleVC : QLPreviewControllerDataSource {
  func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
    return 1
  }

  func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
    return savedImageURL as NSURL
  }
}

extension InLineScribbleVC : PenSizePickerViewControllerDelegate{
    
    func toolPickerViewControllerDidPickTheWidthOfLine(width: CGFloat) {
        drawingView.userSettings.strokeWidth = width
        dismiss(animated: true, completion: nil)

    }
}

private extension NSLayoutConstraint {
  func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
    self.priority = priority
    return self
  }
}

