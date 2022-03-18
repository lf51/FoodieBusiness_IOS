//
//  AccounterVM.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 18/03/22.
//

import Foundation

class AccounterVM: ObservableObject {
    
    // questa classe punta ad essere l'unico ViewModel dell'app. Puntiamo a spostare qui dentro tutto ciò che deve funzionare trasversalmente fra le view, e a sostituire gli altri ViewModel col sistema Struct/@State con cui abbiamo creato un NuovoPiatto, un NuovoIngrediente, e un NuovoMenu.
    
    // ATTUALMENTE NON USATA - IN FASE TEST

    @Published var allTheCommunityIngredients:[CommunityIngredientModel] = [] // tutti gli ingredienti di sistema o della community. Unico elemento "Social" dell'app Business. Published perchè qualora diventasse una communityIngredients dinamica deve aggiornarsi. Nella prima versione, cioè come array di ingredienti caricati dal sistema, potrebbe non essere published, perchè verrebbe caricata in apertura e stop.
    
    @Published var allMyIngredients:[IngredientModel] = [] // tutti gli ingredienti creati dall'accounter
    @Published var allMyDish:[DishModel] = [] // tutti i piatti creati dall'accounter
    @Published var allMyMenu:[MenuModel] = [] // tutti i menu creati dall'accounter
    @Published var allMyProperties:[PropertyModel] = [] // tutte le proprietà registrate dall'accounter
    
    
    
    
    
    
    
    
}
