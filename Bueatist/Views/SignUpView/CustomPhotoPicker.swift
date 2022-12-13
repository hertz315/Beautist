//
//  ProfileImagePicker.swift
//  Bueatist
//
//  Created by Hertz on 12/13/22.
//

import SwiftUI
import PhotosUI
import Combine


struct CustomPhotoPicker: UIViewControllerRepresentable {
    
   
    @StateObject var signUpVM: BeautistViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectedImage: UIImage?
    
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        // PHPickerConfiguration 을 가지고 PHPickerViewController 를 만들어야 합니다.
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 1
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> CustomPhotoPicker.Coordinator {
        return Coordinator(self)
    }
    
    // Use a Coordinator to act as your PHPickerViewControllerDelegate
    class Coordinator: PHPickerViewControllerDelegate {
        
        
        
        private let parent: CustomPhotoPicker
        
        init(_ parent: CustomPhotoPicker) {
            self.parent = parent
        }
        
        // 🎆 유저가 선택을 완료했거나 취소 버튼으로 닫았을 때 알려주는 delegate
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            parent.presentationMode.wrappedValue.dismiss()
            guard !results.isEmpty else {
                return
            }
            
            print(results)
            for item in results {
                item.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.item") { [self] (url, error) in
                    if error != nil {
                        print("error \(error!)");
                    } else {
                        if let url = url {
                            let filename = url.lastPathComponent;
                            print(filename)
                            self.parent.signUpVM.profileImageString = filename
//                            signUpVM.profileImageString = filename
                        }
                    }
                }

            }
            
            
            let imageResult = results[0]
            //
            if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
                imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        DispatchQueue.main.async {
                            self.parent.selectedImage = selectedImage as? UIImage
                        }
                    }
                }
            }
            
            
        } // picker
        
    }
}
