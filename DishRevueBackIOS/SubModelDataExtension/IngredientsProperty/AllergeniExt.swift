//
//  AllergeniExt.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 10/12/22.
//

import Foundation
import SwiftUI
import MyFoodiePackage
import MyFilterPackage

extension AllergeniIngrediente:
   /* MyProStarterPack_L1,*/
    MyProEnumPack_L0 {
    
   public typealias VM = AccounterVM
    
   /* public static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [AllergeniIngrediente]> {
        \.allergeni
    }*/

    public func customInteractiveMenu(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        EmptyView()
    }
    
 /*   public func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [AllergeniIngrediente]>, nomeContainer: String, nomeOggetto:String,imageAssociated:String) {
        
        return (\.allergeni, "Elenco Allergeni", "Allergene","allergens")
    }*/
}

extension AllergeniIngrediente:Property_FPC { }

extension ProvenienzaIngrediente:Property_FPC { }

extension ProduzioneIngrediente:Property_FPC { }

extension OrigineIngrediente:Property_FPC_Mappable { }

extension ConservazioneIngrediente:Property_FPC { }

//extension Inventario.TransitoScorte:Property_FPC { }
extension StatoScorte:Property_FPC { }

extension StatusTransition:Property_FPC { }

extension CategoriaMenu:Property_FPC_Mappable { }

