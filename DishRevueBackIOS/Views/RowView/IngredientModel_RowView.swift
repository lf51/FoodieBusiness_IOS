//
//  IngredientModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/04/22.
//
/*
 Spaghetti,pesto.Bucatini,sugo,basilico.Trofie,gamberi,aglio,olio
 
 */
import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct IngredientModel_RowView: View {

    @EnvironmentObject var viewModel: AccounterVM
    let item: IngredientModel

    var body: some View {
                
        CSZStackVB_Framed {
        
            VStack(alignment:.leading,spacing: 5.0) {
    
                VStack(alignment:.leading,spacing: 0) {
                    
                    vbIntestazioneIngrediente()
                //    vbSubIntestazioneIngrediente()
                    vbDishCountIn()
                    
                }
             
                    .padding(.top,5)
                
             //  Spacer()
                
                HStack {
                    
                    let(image,size) = self.item.associaImmagine()
                    
                    CSText_tightRectangleVisual(fontWeight: .bold, textColor: Color("SeaTurtlePalette_4"), strokeColor: Color("SeaTurtlePalette_1"), fillColor: Color("SeaTurtlePalette_1")) {
                        HStack {
                            csVbSwitchImageText(string: image,size: size)
                            Text(self.item.origine.simpleDescription())
                        }
                    }
                    
                    let isDefaultValue = self.item.provenienza == .defaultValue
                    
                    CSText_tightRectangleVisual(fontWeight: .bold, textColor: Color("SeaTurtlePalette_1"), strokeColor: Color("SeaTurtlePalette_1"), fillColor: Color("SeaTurtlePalette_4")) {
                        HStack {
                            
                            csVbSwitchImageText(string: self.item.provenienza.imageAssociated(),size:.large, slash: isDefaultValue)
                            
                            Text(self.item.provenienza.simpleDescription())
                        }
                    }.opacity(isDefaultValue ? 0.4 : 1.0)
                    
                    Spacer()
                    // 07.09
                   // vbDishCountIn()
                    // end 07.09
                }
                
            //    Spacer()
                
                VStack(spacing:3) {
                    
                    vbProduzioneIngrediente()
                    vbConservazioneIngrediente()
                    vbAllergeneScrollRowView(listaAllergeni: self.item.allergeni)
                    
                }
                .padding(.bottom,5)
             //  .padding(.vertical,5)
     
            } // chiuda VStack madre
           // ._tightPadding()
            .padding(.horizontal,10)
          //  .padding(.vertical,5)
        } // chiusa Zstack Madre
        
    }
    
    // Method
    
    
    /* private func vbSubIntestazioneIngrediente() -> some View {
        
        let riserva = self.item.idIngredienteDiRiserva
        
        var string = "Nessun Ingrediente di Riserva"
        
        if let ingreDiRiserva:IngredientModel = self.viewModel.allMyIngredients.first(where: { $0.id == riserva }) { // usiamo l'optional binding perchè: Nel caso in cui l'ingrediente di riserva sia stato eliminato, l'ingrediente che ha il suo id come riserva, qui scopre che l'ingrediente non esiste più, e dunque non lo indica come riserva.
                
            string = "Sostituibile con --> \(ingreDiRiserva.intestazione)"
                
            }

      return Text(string)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(Color("SeaTurtlePalette_3"))
    } */
    
    @ViewBuilder private func vbDishCountIn() -> some View {
        
        let (dishCount,substitution) = self.item.dishWhereIn(readOnlyVM: self.viewModel)
        let isInPausa = self.item.status.checkStatusTransition(check: .inPausa)
        let isDisponibile = self.item.status.checkStatusTransition(check: .disponibile)
        
        HStack {
            
            CSEtichetta(text: "\(dishCount)",
                        fontStyle: .title3,
                        fontWeight: .semibold,
                        textColor: Color("SeaTurtlePalette_4"),
                        image: "fork.knife.circle",
                        imageColor: Color("SeaTurtlePalette_4"),
                        imageSize: .large,
                        backgroundColor: Color("SeaTurtlePalette_2"),
                        backgroundOpacity: isDisponibile ? 1.0 : 0.4)
            .blur(radius: isDisponibile ? 0.0 : 1.0)
            
            
            if isInPausa {
                
                CSEtichetta(text: "\(substitution)",
                            fontStyle: .title3,
                            fontWeight: .semibold,
                            textColor: Color("SeaTurtlePalette_4"),
                            image: "arrow.left.arrow.right.circle",
                            imageColor: Color("SeaTurtlePalette_4"),
                            imageSize: .large,
                            backgroundColor: Color("SeaTurtlePalette_2"),
                            backgroundOpacity: 1.0)
                
            }
            
            Spacer()
            
            let statoScorte = self.viewModel.inventarioScorte.statoScorteIng(idIngredient: self.item.id)
            
            HStack(spacing:3) {
                
                Text(statoScorte.rawValue)
                        .italic()
                        .bold()
                        .font(.subheadline)
                       
                Image(systemName: statoScorte.imageAssociata())
                    .imageScale(.medium)
                   
            }
            .foregroundColor(statoScorte.coloreAssociato())
            
        }
        
        
        
        
    }
    
   /* private func dishWhereIn() -> (dishCount:Int,Substitution:Int) {
        
        var dishCount: Int = 0
        var dishWhereHasSubstitute: Int = 0
        
        for dish in self.viewModel.allMyDish {
            
            if dish.checkIngredientsInPlain(idIngrediente: self.item.id) {
                dishCount += 1
                if dish.checkIngredientHasSubstitute(idIngrediente: self.item.id) { dishWhereHasSubstitute += 1}
            }
        }
        return (dishCount,dishWhereHasSubstitute)
    } */
    
    @ViewBuilder private func vbProduzioneIngrediente() -> some View {
        
        HStack(spacing: 4.0) {
            
            csVbSwitchImageText(string: self.item.produzione.imageAssociated(), size: .large)
                .foregroundColor(Color.white)
  
            ScrollView(.horizontal, showsIndicators: false) {
                
                Text(self.item.produzione.extendedDescription())
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundColor(Color.white)
                    .italic()
            }
            
        }
        
        
    }
    
    @ViewBuilder private func vbConservazioneIngrediente() -> some View {
        
        HStack(spacing: 4.0) {
            
            csVbSwitchImageText(string: self.item.conservazione.imageAssociated(), size: .large)
                .foregroundColor(Color.white)
  
            ScrollView(.horizontal, showsIndicators: false) {
                
                Text(self.item.conservazione.extendedDescription())
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundColor(Color.white)
                    .italic()
            }
            
        }
        
        
    }
    
    @ViewBuilder private func vbIntestazioneIngrediente() -> some View {
        
        let dashedColor = Color.gray
        
        HStack(alignment:.lastTextBaseline) {
            
            Text(self.item.intestazione)
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(1)
                .allowsTightening(true)
                .foregroundColor(Color.white)
                .overlay(alignment:.topTrailing) {
                    
                    if self.item.produzione == .biologico {
                        
                        Text("Bio")
                            .font(.system(.caption2, design: .monospaced, weight: .black))
                            .foregroundColor(Color.green)
                            .offset(x: 10, y: -4)
                    }
                }
      
            // 07.09
            
         /*   let isRiservaActive = {
                self.item.status == .completo(.inPausa) ||
                self.item.status == .bozza(.inPausa)
            }()
            
            if isRiservaActive {
                
                HStack {
                    let dishCount = dishWhereIn()
                    
                    Text("\(dishCount)")
                    Image(systemName: "arrow.left.arrow.right.circle")
                        .imageScale(.medium)
                        .foregroundColor(isRiservaActive ? Color("SeaTurtlePalette_3") : Color("SeaTurtlePalette_1") )
                        .overlay {
                            
                            if !isRiservaActive {
                                
                                Image(systemName: "circle.slash")
                                    .imageScale(.medium)
                                    .foregroundColor(Color("SeaTurtlePalette_1"))
                                    .rotationEffect(Angle(degrees: 90.0))
                                
                            }
          
                        }
                    
                }
                   
                
            } */

            // end 07.09
            
            Spacer()
            
            vbEstrapolaStatusImage(
                itemModel: self.item,
                dashedColor: dashedColor)
            
        }
        
    }
    
    
    
}


struct IngredientModel_RowView_Previews: PreviewProvider {
    
    @StateObject static var viewModel: AccounterVM = {
        var viewM = AccounterVM()
        viewM.allMyIngredients = [ ingredientSample,ingredientSample2,ingredientSample3,ingredientSample4
        
        ]
        return viewM
    }()
    @State static var ingredientSample =  IngredientModel(
        intestazione: "Guanciale Nero",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .convenzionale,
        provenienza: .restoDelMondo,
        allergeni: [.glutine],
        origine: .animale,
        status: .completo(.disponibile)
    )
    
    @State static var ingredientSample2 =  IngredientModel(
        intestazione: "Merluzzo",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .surgelato,
        produzione: .convenzionale,
        provenienza: .italia,
        allergeni: [.pesce],
        origine: .animale,
        status: .bozza(.disponibile)
            )
    
    @State static var ingredientSample3 =  IngredientModel(
        intestazione: "Basilico",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .biologico,
        provenienza: .restoDelMondo,
        allergeni: [],
        origine: .vegetale,
        status: .completo(.inPausa))
    
    @State static var ingredientSample4 =  IngredientModel(
        intestazione: "Mozzarella di Bufala",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .congelato,
        produzione: .convenzionale,
        provenienza: .europa,
        allergeni: [.latte_e_derivati],
        origine: .animale,
        status: .bozza())
    
    static var previews: some View {
        
        ZStack {
            
            Color("SeaTurtlePalette_1").ignoresSafeArea()
            
            VStack(spacing:50) {
                
                IngredientModel_RowView(item: ingredientSample2)
                    .frame(height:150)
                IngredientModel_SmallRowView(titolare: ingredientSample2, sostituto: nil)
                    .frame(height:50)
              //  IngredientModel_RowView(item: ingredientSample3)
              //  IngredientModel_RowView(item: ingredientSample4)
                
            }
        }.environmentObject(viewModel)
    }
}
