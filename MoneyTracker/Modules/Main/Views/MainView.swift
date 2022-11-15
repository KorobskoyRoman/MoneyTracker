//
//  MainView.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 11.11.2022.
//

import SwiftUI

struct MainView: View {

    var vm: MainViewModelType
    @State private var addCardFormIsPresented = false

    // MARK: - CoreData
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: true)],
        animation: .default
    )
    private var cards: FetchedResults<Card>
    //

    var body: some View {
        NavigationView {
            ScrollView {
                if !cards.isEmpty {
                    TabView {
                        ForEach(cards) { card in
                            CardView()
                                .padding(.bottom, 40)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 280)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                }

                Spacer()
                    .fullScreenCover(isPresented: $addCardFormIsPresented, onDismiss: nil) {
                        AddCardView()
                    }
            }
            .navigationTitle(Titles.navTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addCardButton
                }

//                HStack {
                    ToolbarItem(placement: .navigationBarLeading) {
                        addItemButton
                    }

                    ToolbarItem(placement: .navigationBarLeading) {
                        deleteAllItemsButton
                    }
//                }
            }
        }
    }

    var addCardButton: some View {
        Button(action: {
            addCardFormIsPresented.toggle()
        }, label: {
            let cornerRadius: CGFloat = 5

            Text(Titles.addButtonTitle)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .bold))
                .padding(EdgeInsets(
                    top: 8,
                    leading: 12,
                    bottom: 8,
                    trailing: 12)
                )
                .background(Color.black)
                .cornerRadius(cornerRadius)
        })
    }

    var addItemButton: some View {
        Button("Add item") {
            withAnimation {
                vm.addItem()
            }
        }
    }

    var deleteAllItemsButton: some View {
        Button("Delete all") {
            withAnimation {
                vm.deleteAllItems(cards)
            }
        }
    }
}

extension MainView {
    private enum Titles {
        static let navTitle = "Ваши карты"
        static let addButtonTitle = "+ Добавить"
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        MainView(vm: MainViewModel())
            .environment(\.managedObjectContext, viewContext)
    }
}
