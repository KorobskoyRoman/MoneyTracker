//
//  FilterSheet.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 07.12.2022.
//

import SwiftUI

struct FilterSheet: View {
    let vm: MainViewModelType
    let didSaveFilters: (Set<TransactionCategory>) -> Void
    @State var selectedCategories: Set<TransactionCategory>

    @Environment(\.dismiss) var presentationMode

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionCategory.timestamp,
                                           ascending: false)],
        animation: .default
    )

    private var categories: FetchedResults<TransactionCategory>

    var body: some View {
        NavigationView {
            Form {
                ForEach(categories) { cat in
                    Button {
                        if selectedCategories.contains(cat) {
                            selectedCategories.remove(cat)
                        } else {
                            selectedCategories.insert(cat)
                        }
                    } label: {
                        HStack(spacing: 12) {
                            if let color = vm.getColor(cat: cat) {
                                Spacer()
                                    .frame(width: 30, height: 10)
                                    .background(color)
                            }
                            Text(cat.name ?? "")
                                .foregroundColor(Color(.label))
                            Spacer()

                            if selectedCategories.contains(cat) {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            .navigationTitle(Titles.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
        }
    }

    private var saveButton: some View {
        Button {
            didSaveFilters(selectedCategories)
            presentationMode.callAsFunction()
        } label: {
            Text(Titles.save)
        }

    }
}

extension FilterSheet {
    private enum Titles {
        static let title = "Выберите фильтры"
        static let save = "Применить"
    }
}

struct FilterSheet_Previews: PreviewProvider {
    static var previews: some View {
        FilterSheet(vm: MainViewModel(), didSaveFilters: { cats in

        }, selectedCategories: Set<TransactionCategory>())
    }
}
