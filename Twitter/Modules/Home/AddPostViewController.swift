//
//  AddPostViewController.swift
//  Twitter
//
//  Created by Ivan Mosquera on 22/6/20.
//  Copyright © 2020 Ivan Mosquera. All rights reserved.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift
import FirebaseStorage
import AVFoundation
import AVKit
import MobileCoreServices

class AddPostViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    
    
    // MARK: - Actions
    @IBAction func addPostAction(_ sender: Any) {
        uploadPhotoToFirebase()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openCameraAction() {
        let alert = UIAlertController(title: "Camara", message: "Selecciona una opcion.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Foto", style: .default, handler: { (_) in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { (_) in
            self.openVideoCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil ))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func openPreviewAction() {
        
        guard let currentVidepUrl = currentVideoUrl else{
            return
        }
        let avPlayer = AVPlayer(url: currentVidepUrl)
        
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        
        present(avPlayerController, animated: true){
            avPlayerController.player?.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Properties
    
    private var imagePicker: UIImagePickerController?
    private var currentVideoUrl: URL?
    
    // MARK: - Private methods
    
    private func openVideoCamera(){
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.mediaTypes = [kUTTypeMovie as String]
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .video
        imagePicker?.videoQuality = .typeMedium
        imagePicker?.videoMaximumDuration = TimeInterval(5)
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func openCamera(){
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func uploadPhotoToFirebase(){
        
        //Verificar que la imagen existe.
        //Comprimir la imagen.
        guard let imageSaved = previewImageView.image,
            let imageSavedData: Data = imageSaved.jpegData(compressionQuality: 0.1) else {
                
                return
        }
        
        SVProgressHUD.show()
        
        //Configurar metadata para guardar la foto en firebase.
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        
        //Crear referencia al storage de firebase.
        let storage = Storage.storage()
        
        //Nombre a la imagen a subir.
        let imageName = Int.random(in: 100...1000)
        
        //Crear referencia a la carpeta donde se guarda la foto.
        let folderReference = storage.reference(withPath: "fotos-tweets/\(imageName).jpg")
        
        //Subir la foto a firebase.
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            folderReference.putData(imageSavedData, metadata: metaDataConfig) { (metaData: StorageMetadata?, error: Error?) in
                
                //Volver al hilo principal.
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    
                    if let error = error {
                        NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
                        
                        return
                    }
                    
                    folderReference.downloadURL { (url: URL?, error: Error?) in
                        let downloadUrl = url?.absoluteString ?? ""
                        self.savePost(imageUrl: downloadUrl, videoUrl: nil)
                    }
                }
            }
        }
    }
    
    private func uploadVideoToFirebase(){
        
        //Verificar que el video existe.
        //Convertir en data el video.
        guard let currentVideoSavedUrl = currentVideoUrl,
            let videoData: Data = try? Data(contentsOf: currentVideoSavedUrl) else {
                return
        }
        
        SVProgressHUD.show()
        
        //Configurar metadata para guardar la foto en firebase.
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "video/MP4"
        
        //Crear referencia al storage de firebase.
        let storage = Storage.storage()
        
        //Nombre del video a subir.
        let videoName = Int.random(in: 100...1000)
        
        //Crear referencia a la carpeta donde se guarda el video.
        let folderReference = storage.reference(withPath: "video-tweets/\(videoName).mp4")
        
        //Subir el video a firebase.
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            folderReference.putData(videoData, metadata: metaDataConfig) { (metaData: StorageMetadata?, error: Error?) in
                
                //Volver al hilo principal.
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    
                    if let error = error {
                        NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
                        
                        return
                    }
                    
                    folderReference.downloadURL { (url: URL?, error: Error?) in
                        let downloadUrl = url?.absoluteString ?? ""
                        self.savePost(imageUrl: nil, videoUrl: downloadUrl)
                    }
                }
            }
        }
    }
    
    private func savePost(imageUrl: String?, videoUrl: String?){
        
        guard let postText = postTextView.text, !postText.isEmpty else{
            
            return
        }
        
        let request = PostRequest(text: postText, imageUrl: imageUrl, videUrl: videoUrl, location: nil)
        SVProgressHUD.show()
        
        SN.post(endpoint: EndPoints.post, model: request) { (response: SNResultWithEntity<Post, ErrorResponse>) in
            SVProgressHUD.dismiss()
            
            switch response{
                
            case .success(let post):
                self.dismiss(animated: true, completion: nil)
                
            case .error(error: let error):
                NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
                
            case .errorResult(entity: let entity):
                NotificationBanner(title: "Error", subtitle: entity.error, style: .warning).show()
            }
        }
    }
    

}

// MARK: - UIImagePickerControllerDelegate

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Cerrar camara
        imagePicker?.dismiss(animated: true, completion: nil)
        
        //Capturar imagen
        if info.keys.contains(.originalImage){
            previewImageView.isHidden = false
            previewImageView.image = info[.originalImage] as? UIImage
        }
        
        //Aqui capturamos la url del video
        if info.keys.contains(.mediaURL), let recordedVideoUrl = (info[.mediaURL] as? URL)?.absoluteURL{
            videoButton.isHidden = false
            currentVideoUrl = recordedVideoUrl
        }
    }
}

