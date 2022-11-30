//
//  TransactionView.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 24.11.2022.
//

import SwiftUI
import PhotosUI

struct NewTransactionView: View {
    let vm: MainViewModelType
    let card: Card

    @Environment(\.dismiss) var presentationMode

    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var presentedPhotoPicker = false

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(Titles.info) {
                    TextField(Titles.name, text: $name)
                    TextField(Titles.amount, text: $amount)
                    DatePicker(Titles.date,
                               selection: $date,
                               displayedComponents: .date)
                }

                Section(Titles.category) {
                    NavigationLink {

                    } label: {
                        Text(Titles.categoryType)
                    }
                }

                Section(Titles.phoro) {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text("Select a photo")
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }

                    if let selectedImageData = selectedImageData,
                       let uiImage = UIImage(data: selectedImageData)?
                        .resized(to: .init(width: 250, height: 250)) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                    }
                }
            }
            .navigationTitle(Titles.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }

            }
        }
    }

    private var cancelButton: some View {
        Button(action: {
            presentationMode.callAsFunction()
        }, label: {
            Text(Titles.cancel)
                .foregroundColor(.red)
        })
    }

    private var saveButton: some View {
        Button(action: {
            vm.saveTransaction(name: name,
                               timestamp: date,
                               amount: amount,
                               photoData: selectedImageData,
                               card: card)
            presentationMode.callAsFunction()
        },
               label: {
            Text(Titles.save)
        })
    }

}

extension NewTransactionView {
    private enum Titles {
        static let title = "Добавить покупку"
        static let cancel = "Отмена"
        static let save = "Сохранить"
        static let info = "Информация"
        static let phoro = "Фото"
        static let name = "Название"
        static let amount = "Описание"
        static let date = "Дата"
        static let type = "Тип"
        static let select = "Выбрать фото"
        static let category = "Категории"
        static let categoryType = "Выбрать категорию"
    }
}

//struct TransactionView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewTransactionView(vm: MainViewModel(), card: <#Card#>)
//    }
//}
