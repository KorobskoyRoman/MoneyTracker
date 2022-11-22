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
                            CardView(card: card, vm: vm)
                                .padding(.bottom, 40)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 280)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                } else {
                    noCardView
                }

                Spacer()
                    .fullScreenCover(isPresented: $addCardFormIsPresented, onDismiss: nil) {
                        AddCardView(vm: vm)
                    }
            }
            .navigationTitle(Titles.navTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addCardButton
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    addItemButton
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    deleteAllItemsButton
                }
            }
        }
    }

    private var addCardButton: some View {
        Button(action: {
            addCardFormIsPresented.toggle()
        }, label: {
            Text(Titles.addButtonTitle)
                .foregroundColor(Color(.systemBackground))
        })
        .foregroundColor(.white)
        .font(.system(size: 14, weight: .bold))
        .padding(EdgeInsets(
            top: 8,
            leading: 12,
            bottom: 8,
            trailing: 12)
        )
        .background(Color(.label))
        .cornerRadius(5)
    }

    private var addItemButton: some View {
        Button("Add item") {
            withAnimation {
                vm.addItem()
            }
        }
    }

    private var deleteAllItemsButton: some View {
        Button("Delete all") {
            withAnimation {
                vm.deleteAllItems(cards)
            }
        }
    }

    private var noCardView: some View {
        VStack {
            let cornerRadius: CGFloat = 5

            Text(Titles.noCardsTitle)
                .padding(.horizontal, 48)
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Button {
                addCardFormIsPresented.toggle()
            } label: {
                Text(Titles.addFirstCardTitle)
                    .foregroundColor(Color(.systemBackground))
            }
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .semibold))
            .padding(EdgeInsets(
                top: 8,
                leading: 12,
                bottom: 8,
                trailing: 12)
            )
            .background(Color(.label))
            .cornerRadius(cornerRadius)
        }
        .font(.system(size: 22, weight: .semibold))
    }
}

extension MainView {
    private enum Titles {
        static let navTitle = "Ваши карты"
        static let addButtonTitle = "+ Добавить"
        static let noCardsTitle = "Нет доступных для отображения карт. Хотите добавить?"
        static let addFirstCardTitle = "+ Добавить первую карту"
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        MainView(vm: MainViewModel())
            .environment(\.managedObjectContext, viewContext)
    }
}
