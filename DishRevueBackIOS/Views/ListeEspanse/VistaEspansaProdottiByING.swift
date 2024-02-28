//
//  VistaEspansaProdottiByING.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 20/02/24.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage
import MyFilterPackage

struct VistaEspansaProdottiByING: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let currentING: IngredientModel
    let backgroundColorView: Color
    let allProducts:[ProductModel]
   // @State private var container:[String]

    init(currentING: IngredientModel, backgroundColorView: Color,readOnlyVM:AccounterVM) {
        
        self.currentING = currentING
        self.backgroundColorView = backgroundColorView
        self.allProducts = readOnlyVM.allDishContainingIngredient(idIng: currentING.id)
   
    }
    
    var body: some View {
        
        CSZStackVB(title: currentING.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
                HStack {
                    
                    let statusTransition = self.currentING.getStatusTransition()
                    Text("Attualmente:")
                        .font(.system(.body,design: .rounded))
                    
                    CSEtichetta(
                        text: statusTransition.simpleDescription(),
                        textColor: Color.white,
                        image:
                            self.currentING.status.imageAssociated(),
                        imageColor: statusTransition.colorAssociated(),
                        imageSize: .large,
                        backgroundColor: Color.white, backgroundOpacity: 0.2)
                    Spacer()
                    
                }
                
                // description
                vbIngDescription()
                
                
                ScrollView(showsIndicators:false) {
                    
                    VStack {
                        
                        ForEach(allProducts) { model in
    
                                vbGenericRow(model: model)
                            
                        }
                    }
                }
                CSDivider()
            }
            .csHpadding()
            
        }
        
    }
    
    // ViewBuilder
    @ViewBuilder private func vbGenericRow<M:MyProVisualPack_L0>(model:M) -> some View  where M.RS == RowSize, M.VM == AccounterVM {
        
        VStack(alignment: .leading, spacing:0) {
         
            vbLabelBuilder(product: model as! ProductModel)
            
                GenericItemModel_RowViewMask(model: model, pushImage: "line.diagonal.arrow") {
                    
                    Button {
                        self.viewModel.showSpecificModel = model.id
                        self.viewModel.pathSelection = .dishList
                    } label: {
                        Text("Vai al Prodotto")
                        Image(systemName: "arrow.up.forward.app")
                    }

                }
        }
    }
    
    @ViewBuilder private func vbLabelBuilder(product:ProductModel) -> some View {
        
        let label:String? = labelBuilderFor(product: product)
        
        if let label {
            
            Text(label)
                .bold()
                .font(.system(.subheadline,design: .monospaced))
                .foregroundColor(Color.black)
                .padding([.vertical,.leading],5)
                .padding(.trailing,20)
                .opacity(1.0)
                .background {
                    Rectangle()
                        .fill(Color.white)
                        .opacity(0.1)
                        .csCornerRadius(5, corners: [.topLeft])
                        .csCornerRadius(50, corners: .topRight)
                        .shadow(color: .seaTurtle_1, radius: 1.0, x: 1)
                       // .opacity(isSelected ? 0.1 : 0.025)
                }
            
        }

    }
    
    @ViewBuilder private func vbIngDescription() -> some View {
        
        // numero prodotti / %
        let allProduct = self.allProducts.count
        let allInDatabase = self.viewModel.db.allMyDish.count
        let usePercent:Double = Double(allProduct) / Double(allInDatabase)
        let useValuePercent = String(format:"%.1f%%",(usePercent * 100))
        
        let allMappedByUse = self.allProducts.compactMap({$0.individuaUtilizzoIngrediente(idIngrediente: self.currentING.id)})
        
        let asPrincipal = allMappedByUse.filter({$0 == .principale}).count
        let asSecondary = allMappedByUse.filter({$0 == .secondario}).count
        
        let all = allMappedByUse.count
        
        let asSubs = all - (asPrincipal + asSecondary)
        
        let allProductsId = self.allProducts.map({$0.id})
        let media = self.viewModel.mediaValoreRecensioni(for:allProductsId )
        let mediaString = String(format:"%.1f",media)
        
        // Come principale: count/%
        // Come secondario: count/%
        // Come sostituto: count
        // media voto dei prodotti
        
        VStack(alignment: .leading,spacing: 2) {
            
            Group {
                
                HStack {
                    
                    Text("Utilizzato in: \(allProduct) preparazioni su \(allInDatabase) - (\(useValuePercent))")
                    Spacer()
                    Text("Voto Medio: \(mediaString)")
                        .bold()
                    
                }
                
                Text("Come Ingrediente Principale: \(asPrincipal) volte")
                
                Text("Come Ingrediente Secondario: \(asSecondary) volte")
                
                Text("Come Sostituto: \(asSubs) volte")
            }
            .font(.caption)
            .fontWeight(.light)
            .foregroundStyle(Color.black)
            .opacity(0.8)
        }
        
        
        
    }
    
    // method
    
    private func labelBuilderFor(product:ProductModel) -> String? {
        
        guard let utilizzoIngrediente = product.individuaUtilizzoIngrediente(idIngrediente: self.currentING.id) else {
            return nil
        }
       
       let usoDefinitivo:ProductModel.UtilizzoIngredient
        
       switch utilizzoIngrediente {
           
        case .principale,.secondario:
            usoDefinitivo = utilizzoIngrediente
        case .sostituto(let idTitolare):
            
            if let model = self.viewModel.modelFromId(id: idTitolare, modelPath: \.db.allMyIngredients) {
                
                usoDefinitivo = .sostituto(model.intestazione)
            } else { return nil }
        }
        
        return usoDefinitivo.simpleDescription()
        
    }
    
}
