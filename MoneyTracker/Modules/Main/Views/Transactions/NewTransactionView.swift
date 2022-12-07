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

    init(vm: MainViewModelType, card: Card) {
        self.card = card
        self.vm = vm

        guard let first = vm.prefetchCategory() else { return }
        self._selectedCategories = .init(initialValue: [first])
    }

    @Environment(\.dismiss) var presentationMode

    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var presentedPhotoPicker = false
    @State private var selectedCategories = Set<TransactionCategory>()

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(Titles.info) {
                    TextField(Titles.name, text: $name)
                    TextField(Titles.amount, text: $amount)
                        .keyboardType(.numberPad)
                    DatePicker(Titles.date,
                               selection: $date,
                               displayedComponents: .date)
                }

                Section(Titles.category) {
                    NavigationLink {
                        CategoriesListView(vm: vm, selectedCategories: $selectedCategories)
                    } label: {
                        Text(Titles.categoryType)
                    }

                    let sortedCats = vm.sortCats(selectedCategories)

                    ForEach(sortedCats) { cat in
                        HStack(spacing: 12) {
                            if let data = cat.colorData,
                               let uiColor = UIColor.color(data: data) {
                                let color = Color(uiColor)
                                Spacer()
                                    .frame(width: 30, height: 10)
                                    .background(color)
                            }

                            Text(cat.name ?? "")
                        }
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
            vm.saveTransaction(
                name: name,
                timestamp: date,
                amount: amount,
                photoData: selectedImageData,
                card: card,
                selectedCategories: selectedCategories
            )
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
