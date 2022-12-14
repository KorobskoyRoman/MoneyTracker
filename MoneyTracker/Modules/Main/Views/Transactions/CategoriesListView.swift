//
//  CategoriesListView.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 30.11.2022.
//

import SwiftUI

struct CategoriesListView: View {
    let vm: MainViewModelType

    @State private var name = ""
    @State private var color = Color.red
    @Binding var selectedCategories: Set<TransactionCategory>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionCategory.timestamp,
                                           ascending: false)],
        animation: .default
    )

    private var categories: FetchedResults<TransactionCategory>

    var body: some View {
        Form {
            Section(Titles.selectCategory) {
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
                .onDelete { indx in
                    indx.forEach { i in
                        let category = categories[i]
                        selectedCategories.remove(category)
                        vm.deleteCategory(category)
                    }
                }
            }

            Section(Titles.createCategory) {
                TextField(Titles.name, text: $name)

                ColorPicker(Titles.color, selection: $color)

                Button {
                    handleCreate()
                } label: {
                    HStack {
                        Spacer()
                        Text(Titles.create)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .foregroundColor(Color(.white))
                    .background(Color.blue)
                    .cornerRadius(5)
                }.buttonStyle(PlainButtonStyle())
            }
        }.navigationTitle(Titles.title)
    }

    private func handleCreate() {
        vm.createCategory(name: name, color: color)
        self.name = ""
    }
}

extension CategoriesListView {
    private enum Titles {
        static let title = "??????????????????"
        static let selectCategory = "???????????????? ??????????????????"
        static let createCategory = "?????????????? ???????? ??????????????????"
        static let name = "????????????????"
        static let color = "????????"
        static let create = "????????????????"
    }
}

struct CategoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesListView(vm: MainViewModel(), selectedCategories: .constant(Set<TransactionCategory>()))
            .environment(\.managedObjectContext,
                          PersistenceController.shared.container.viewContext)
    }
}
