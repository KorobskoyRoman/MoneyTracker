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
    @State private var addTransactionFormIsPresented = false
    @State private var cardSelectionIndex = 0
    @State private var selectedCardHash = -1

    // MARK: - CoreData
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default
    )

    private var cards: FetchedResults<Card>
    // CoreData

    var body: some View {
        NavigationView {
            ScrollView {
                if !cards.isEmpty {

                    TabView(selection: $selectedCardHash) {
                        ForEach(cards) { card in
                            CardView(card: card, vm: vm)
                                .padding(.bottom, 40)
                                .tag(card.hash)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 280)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))

                    Text(Titles.addTransaction)
                    Button {
                        addTransactionFormIsPresented.toggle()
                    } label: {
                        Text(Titles.addTransactionButton)
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
                            .onAppear {
                                self.selectedCardHash = cards.first?.hash ?? -1
                            }
                    }
                    .fullScreenCover(isPresented: $addTransactionFormIsPresented) {
                        if let firstIndex = cards.firstIndex(where: {
                            $0.hash == selectedCardHash }) {
                            let card = self.cards[firstIndex]
                            NewTransactionView(vm: vm, card: card)
                        }
                    }

                    if let firstIndex = cards.firstIndex(where: {
                        $0.hash == selectedCardHash }) {
                        let card = self.cards[firstIndex]
                        TransactionsView(vm: vm, card: card)
                    }
                } else {
                    noCardView
                }

                Spacer()
                    .fullScreenCover(isPresented: $addCardFormIsPresented, onDismiss: nil) {
                        AddCardView(vm: vm, card: nil) { card in
                            self.selectedCardHash = card.hash
                        }
                    }
            }
            .navigationTitle(Titles.navTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addCardButton
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Text(Titles.countOfCards + "\(cards.count)")
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
        static let addTransaction = "Начните с добавления первой покупки!"
        static let addTransactionButton = "+ Транзакция"
        static let countOfCards = "Карт введено: "
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        MainView(vm: MainViewModel())
            .environment(\.managedObjectContext, viewContext)
    }
}
