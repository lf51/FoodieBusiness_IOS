//
//  PropertyModelExt.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 10/12/22.
//

import Foundation
import MyFoodiePackage
import SwiftUI

extension PropertyModel:
    MyProStarterPack_L1,
    MyProVisualPack_L0,
    MyProDescriptionPack_L0 {
    
    public typealias VM = AccounterVM
    public typealias RS = RowSize
    
    public static func basicModelInfoTypeAccess() -> ReferenceWritableKeyPath<AccounterVM, [PropertyModel]> {
        return \.cloudData.allMyProperties
    }
    
   /* public func documentDataForFirebaseSavingAction(positionIndex:Int?) -> [String : Any] {
        
        let documentData:[String:Any] = [
        
            DataBaseField.intestazione : self.intestazione,
            DataBaseField.descrizione : self.descrizione,
            DataBaseField.cityName : self.cityName,
            DataBaseField.webSite : self.webSite,
            DataBaseField.phoneNumber : self.phoneNumber,
            DataBaseField.streetAdress : self.streetAdress,
            DataBaseField.numeroCivico : self.numeroCivico,
            DataBaseField.latitude : self.coordinates.latitude.description,
            DataBaseField.longitude : self.coordinates.longitude.description
        ]
        
        return documentData
    } */

    public func vbMenuInterattivoModuloCustom(viewModel:AccounterVM,navigationPath:ReferenceWritableKeyPath<AccounterVM,NavigationPath>) -> some View {
        
        VStack {
            
            Button {
               // viewModel.deleteItemModel(itemModel: property)
            } label: {
                HStack {
                    
                    Image(systemName:"eye")
                    Text("Vedi Info")
                    
                }
            }
            
            Button {
               viewModel[keyPath: navigationPath].append(DestinationPathView.property(self))
            } label: {
                HStack {
                    Image(systemName:"arrow.up.forward.square")
                    Text("Edit")
                }
            }
            
            Button {
               // viewModel.deleteItemModel(itemModel: property)
            } label: {
                HStack {
                    
                    Image(systemName:"person.badge.shield.checkmark.fill")
                    Text("Chiedi Verifica")
                    
                }
            }.disabled(true)
            
            Button(role:.destructive) {
               // viewModel.deleteItemModel(itemModel: self)
              //  viewModel.deleteProperty(property: self)
                viewModel.deletePropertyExecutive(property: self)
            } label: {
                HStack {
                    Image(systemName:"trash")
                    Text("Elimina")
                    
                }
            }
            
         
        }
    }
    
    public func conditionToManageMenuInterattivo() -> (disableCustom: Bool, disableStatus: Bool, disableEdit: Bool, disableTrash: Bool, opacizzaAll: CGFloat) {
        (false,false,false,false,1.0)
    }
    
    public func returnModelRowView(rowSize:RowSize) -> some View {
        // row size non implementata
        PropertyModel_RowView(itemModel: self)
    }
    
    public func basicModelInfoInstanceAccess() -> (vmPathContainer: ReferenceWritableKeyPath<AccounterVM, [PropertyModel]>, nomeContainer: String, nomeOggetto:String,imageAssociated:String) {
        
        return (\.cloudData.allMyProperties,"Lista Proprietà", "Proprietà","house")
    }

    
} // end extension
