//
//  DishModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

public enum RowSize:Equatable,Hashable { // Nota 22.06.23

    case sintetico
    case ridotto
    case normale(_ limitedTo:CGFloat? = nil)
  //  case ibrido(_ limitedTo:CGFloat? = nil)
    
    func returnType() -> RowSize {
        
        switch self {
        case .sintetico:
            return .sintetico
        case .ridotto:
            return .ridotto
        case .normale(_):
            return .normale()
       /* case .ibrido(_):
            return .ibrido() */
        }
    }
    
    func getFrameWidth() -> CGFloat? {
        
        switch self {
        case .sintetico:
            return 300
        case .ridotto:
            return 300
        case .normale(let width):
            return width
       /* case .ibrido(let width):
            return width */

        }
        
    }
    
}

struct DishModel_RowView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let item: DishModel
    let rowSize:RowSize
    
    @State private var showDescription:Bool = false
    
    init(item: DishModel, rowSize: RowSize = .normale()) {
        
        self.item = item
        self.rowSize = rowSize
        
  
       /* let checkIsIbrido = item.percorsoProdotto == .prodottoFinito
        let plaiRowSize = rowSize.returnType()
        
        if checkIsIbrido && plaiRowSize == .normale() {
            self.rowSize = .ibrido(plaiRowSize.getFrameWidth())
        } else {
            self.rowSize = rowSize
        } */
    }
    
    var body: some View { vbSwitchRowSize() }
    
    // View da Switchare
    
    @ViewBuilder private func vbSwitchRowSize() -> some View {
        
        switch rowSize {
            
        case .sintetico:
            vbSinteticRow()
        case .ridotto:
            vbSmallRow()
        case .normale:
            vbNormalRow()
       /* case .ibrido:
           vbIbridoRow() */
        }
    }
    
    
  /*  @ViewBuilder private func vbRowEstesa() -> some View {
        
        switch self.item.percorsoProdotto {
            
        case .prodottoFinito:
            vbIbridoRow()
        case .composizione:
            vbIbridoRow()
        default:
            vbNormalRow()
        }
        
    } */
    
    

    /*@ViewBuilder private func vbIbridoRow() -> some View {
        
        CSZStackVB_Framed(frameWidth:rowSize.getFrameWidth()) {
            
            VStack(alignment:.leading) {
                
                VStack {

                    vbIntestazioneDishRow()
                    vbSubIntestazioneDishRow()
 
                }
                 .padding(.top,5)
                
                Spacer()
                
                VStack(spacing:10) {
                    
                    vbBadgeRow()
                    vbIngredientQuality()
                   // vbIngredientScrollRow()
                    vbDieteCompatibili()
                }
                
                Spacer()
                
             //  VStack(spacing:5){
                    
                   // vbDieteCompatibili()

                    let listaAllergeni = self.item.calcolaAllergeniNelPiatto(viewModel: self.viewModel)
                    vbAllergeneScrollRowView(listaAllergeni: listaAllergeni)
                     .padding(.bottom,5)
                       
             //   }
               
                
            } // chiuda VStack madre
            .padding(.horizontal,10)
                            
        } // chiusa Zstack Madre
        
    }*/ // deprecato 24.06.23
    
    @ViewBuilder private func vbSinteticRow() -> some View {
        
        CSZStackVB_Framed(frameWidth:rowSize.getFrameWidth()) {
            
            VStack(alignment:.leading) {

                    vbIntestazioneDishRow()
                    vbSubIntestazioneDishRow()

            } // chiuda VStack madre
            .padding(.vertical,5)
            .padding(.horizontal,10)
            
        }
    }
    
    @ViewBuilder private func vbNormalRow() -> some View {
        
        let percorsoIbrido:Bool = {
            self.item.percorsoProdotto == .composizione ||
            self.item.percorsoProdotto == .prodottoFinito
        }()
        
        CSZStackVB_Framed(frameWidth:rowSize.getFrameWidth()) {
            
            VStack(alignment:.leading) {
                
                VStack {

                    vbIntestazioneDishRow()
                    vbSubIntestazioneDishRow()
 
                }
                 .padding(.top,5)
                
                Spacer()
                
                VStack(alignment:.leading,spacing:10) {
                    
                    vbBadgeRow()
                    
                    if showDescription {
                        
                       vbDescriptionScrollRow()
                    }
                    else if percorsoIbrido { vbIngredientQuality() }
                    else { vbIngredientScrollRow() }
                    
                   /* if percorsoIbrido {vbIngredientQuality()}
                    else {vbIngredientScrollRow()} */
                    
                    vbDieteCompatibili()
                }
                
                Spacer()
                
             //  VStack(spacing:5){
                    
                   // vbDieteCompatibili()

                    let listaAllergeni = self.item.calcolaAllergeniNelPiatto(viewModel: self.viewModel)
                    vbAllergeneScrollRowView(listaAllergeni: listaAllergeni)
                     .padding(.bottom,5)
                       
             //   }
               
                
            } // chiuda VStack madre
            .padding(.horizontal,10)
                            
        } // chiusa Zstack Madre
        
    }
    
    @ViewBuilder private func vbSmallRow() -> some View {
        
        CSZStackVB_Framed(frameWidth:rowSize.getFrameWidth()) {
            
            VStack(alignment:.leading) {
                
                VStack(alignment:.leading) {

                    vbIntestazioneDishRow()
                    vbSubIntestazioneDishRow()
                
                }
                 .padding(.top,5)
                
                Spacer()
                vbBadgeRow()
                vbNoticeAllergeni()
                    .padding(.bottom,5)

            } // chiuda VStack madre
            .padding(.horizontal,10)
            
        } // chiusa Zstack Madre
      /*  .overlay(alignment: .bottomTrailing) {
       // !! NOTA VOCALE 20.09 BADGE !!
            HStack(alignment: .center,spacing:2) {
                
                Image(systemName: "fork.knife.circle.fill")
                    .imageScale(.small)
                    .foregroundColor(Color.yellow)
                Text("del Giorno")
                    .bold()
                    .font(.caption)
                    .foregroundColor(Color.white)
                    
            }
            .padding(2)
            .background(content: {
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color.yellow.opacity(0.4))
            })
                .offset(x: -5, y: -5)
            
        } */
    }
    
    // Method
    
    /// solo per viewRow ibride
    @ViewBuilder private func vbIngredientQuality() -> some View {
        
        if let modelDS = self.viewModel.modelFromId(id: self.item.id, modelPath: \.allMyIngredients) {
            
            let conservazione = modelDS.conservazione
            let origine = modelDS.origine
            let provenienza = modelDS.provenienza
            
            HStack {
                
                ScrollView(.horizontal,showsIndicators: false) {
                    
                    HStack {
                        
                        CSEtichetta(
                            text: "\(conservazione.simpleDescription())",
                            fontStyle: .headline,
                            fontWeight: .semibold,
                            fontDesign: .default,
                            textColor: .seaTurtle_4,
                            image: conservazione.imageAssociated(),
                            imageColor: nil,
                            imageSize: .large,
                            backgroundColor: .seaTurtle_4,
                            backgroundOpacity: 0.2)
                        
                        
                        CSEtichetta(
                            text: "\(origine.simpleDescription())",
                            fontStyle: .headline,
                            fontWeight: .semibold,
                            fontDesign: .default,
                            textColor:.seaTurtle_4,
                            image: origine.imageAssociated(),
                            imageColor: nil,
                            imageSize: .large,
                            backgroundColor: .seaTurtle_1,
                            backgroundOpacity: 1.0)
                        
                        CSEtichetta(
                            text: "\(provenienza.simpleDescription())",
                            fontStyle: .headline,
                            fontWeight: .semibold,
                            fontDesign: .default,
                            textColor: .seaTurtle_1,
                            image: provenienza.imageAssociated(),
                            imageColor: nil,
                            imageSize: .large,
                            backgroundColor: .seaTurtle_4,
                            backgroundOpacity: 0.8)
                    }
                    
                }
                
                
            }
            
            
            
        }
        
    }
    
    @ViewBuilder private func vbBadgeRow() -> some View {
        
        // 19.10
      //  let areAllBio = self.item.areAllIngredientBio(viewModel: self.viewModel)
        let areAllBio = self.item.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.produzione, quality: .biologico)
        let areAllLocal = self.item.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.provenienza, quality: .km0)
        let areAllItalian = self.item.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.provenienza, quality: .italia)
        
        let basePreparazione = self.item.calcolaBaseDellaPreparazione(readOnlyVM: self.viewModel)
        
        // end 19.10
        let isDelGiorno = self.viewModel.checkMenuDiSistemaContainDish(idPiatto: self.item.id, menuDiSistema: .delGiorno)
        let isAdviceByTheChef = self.viewModel.checkMenuDiSistemaContainDish(idPiatto: self.item.id, menuDiSistema: .delloChef)
  
      /*  let menuWhereIsIn = self.viewModel.allMenuMinusDiSistemaPlusContain(idPiatto: self.item.id).countWhereDishIsIn */ // deprecata 19.10 - Indichiamo tutti i menu, anche quelli di sistema
        let menuWhereIsIn = self.viewModel.allMenuContaining(idPiatto: self.item.id).countWhereDishIsIn
        // end 19.10
        
       // let isIbrido = self.rowSize.returnType() == .ibrido()
        let isIbrido = self.item.percorsoProdotto == .prodottoFinito
        let isNotDescribed = self.item.descrizione == ""
        
        HStack {
         
            CSEtichetta(
                text: "\(menuWhereIsIn)",
                fontStyle: .subheadline,
                fontWeight: .semibold,
                textColor: .seaTurtle_4,
                image: "menucard",
                imageColor: .seaTurtle_4,
                imageSize: .medium,
                backgroundColor:.seaTurtle_2,
                backgroundOpacity: 1.0)
           /* .onTapGesture {
                self.viewModel.alertItem = AlertModel(
                    title: "Lista Menu",
                    message: "Indica il numero di menu stabili dove è inserito il piatto. Non considera il menu del giorno e il menu dei consigliati dallo chef.")
            } */ // Tolto 04.10
            
            if isIbrido {
                
                let statoScorte = self.viewModel.inventarioScorte.statoScorteIng(idIngredient: self.item.id)
                
                CSEtichetta(
                    text: statoScorte.rawValue,
                    fontStyle: .subheadline,
                    fontWeight: .semibold,
                    fontDesign: .default,
                    textColor: .seaTurtle_1,
                    image: statoScorte.imageAssociata(),
                    imageColor: .seaTurtle_1,
                    imageSize: .medium,
                    backgroundColor: statoScorte.coloreAssociato(),
                    backgroundOpacity: 1.0)

            } else {
                                
                CSEtichetta(
                    text: "",
                    textColor: .seaTurtle_2,
                    image: basePreparazione.imageAssociate(),
                    imageColor: nil,
                    imageSize: .large,
                    backgroundColor:Color.white.opacity(0),
                    backgroundOpacity: 1.0)
                
            }

            ScrollView(.horizontal,showsIndicators: false){
                
                HStack {
                    
                    if areAllBio {
                        
                        CSEtichetta(
                            text: "BIO",
                            textColor: .seaTurtle_1,
                            image: "💯",
                            imageColor: nil,
                            imageSize: .large,
                            backgroundColor: Color.green,
                            backgroundOpacity: 1.0)
                      /*  .onTapGesture {
                            self.viewModel.alertItem = AlertModel(
                                title: "100% Bio",
                                message: "Indica che tutti gli ingredienti usati nella preparazione del piatto sono prodotti con Metodo Biologico")
                        } */ // Tolto 04.10
                    }
                
                    if !isIbrido {
                        
                        if areAllItalian {
                            
                            CSEtichetta(
                                text: "🇮🇹",
                                fontStyle: .subheadline,
                                textColor: Color.white,
                                image: "💯",
                                imageColor: nil,
                                imageSize: .large,
                                backgroundColor: Color.white.opacity(0.5),
                                backgroundOpacity: 1.0)
                        }
                        
                        if areAllLocal {
                            
                            CSEtichetta(
                                text: "locale",
                                textColor: Color.white,
                                image: "💯",
                                imageColor: nil,
                                imageSize: .large,
                                backgroundColor: Color.yellow.opacity(0.5),
                                backgroundOpacity: 1.0)
                        }
                    }
                    
                    if isDelGiorno {
                        
                        CSEtichetta(
                            text: "del Giorno",
                            textColor: Color.white,
                            image: "fork.knife.circle.fill",
                            imageColor: Color.yellow,
                            imageSize: .medium,
                            backgroundColor: Color.pink,
                            backgroundOpacity: 0.5)
                    }

                    if isAdviceByTheChef {
                        
                        CSEtichetta(
                            text: "dello Chef",
                            textColor: Color.white,
                            image: "👨🏻‍🍳", //"🗣️", // person.wave.2
                            imageColor: nil,
                            imageSize: .large,
                            backgroundColor: Color.purple,
                            backgroundOpacity: 0.7)
                    }
                    
                } // chiusa HStack Interno
                
            } // chiusa ScrollHorizontal
            
            let describeButton:Color = isNotDescribed ? .gray : .seaTurtle_4
            
            
            CSButton_image(
                activationBool: self.showDescription,
                frontImage: "arrow.triangle.2.circlepath",
                imageScale: .medium,
                backColor: .seaTurtle_2,
                frontColor: describeButton,
                rotationDegree: 120) {
                    withAnimation(.linear) {
                        self.showDescription.toggle()
                    }
                }
                .shadow(color: .gray, radius: 1.0,x:1.5)
                .csModifier(self.rowSize != .normale(), transform: { image in
                    image
                        .hidden()
                })
                .disabled(isNotDescribed)
   

        } // end HastackMadre
    }
    
    @ViewBuilder private func vbNoticeAllergeni() -> some View {
        
        let listaAllergeni = self.item.calcolaAllergeniNelPiatto(viewModel: self.viewModel)
        let string = listaAllergeni.isEmpty ? "Non contiene Allergeni" : "Contiene Allergeni"
    
        HStack(spacing:4.0) {
            Image(systemName: "allergens")
                .imageScale(.medium)
            Text(string)
        }
        .fontWeight(.semibold)
        .font(.caption)
        .underline(!listaAllergeni.isEmpty)
        .foregroundColor(Color.black)
    }
    
    @ViewBuilder private func vbIntestazioneDishRow() -> some View {
        
        let value:(font:Font,imageSize:Image.Scale) = {
           
            if self.rowSize.returnType() == .normale() { return (.title2,.medium)}
            else { return (.title3,.small)}
        }()
        
        let dashedColor:Color = {
            
            if self.item.percorsoProdotto == .prodottoFinito {
                
               return self.viewModel.inventarioScorte.statoScorteIng(idIngredient: self.item.id).coloreAssociato()
                
            } else if self.item.percorsoProdotto == .composizione { return DishModel.ExecutionState.eseguibileConRiserva.coloreAssociato() }
            
            else {
                return self.item.checkStatusExecution(viewModel: self.viewModel).coloreAssociato()
            }
        }()
        
        let percorsoImage = self.item.percorsoProdotto.imageAssociated()
        
        HStack(alignment:.center,spacing: 3) {
            
            Image(systemName: percorsoImage.system)
                .imageScale(value.imageSize)
                .foregroundColor(percorsoImage.color)
            
            Text(self.item.intestazione)
                .font(value.font)
                .fontWeight(.semibold)
                .lineLimit(1)
                .allowsTightening(true)
                .foregroundColor(Color.white)
              //  .fixedSize()
            
            Spacer()
            
            vbEstrapolaStatusImage(
                itemModel: self.item,
                dashedColor: dashedColor)
            
        }
        
    }
    
    @ViewBuilder private func vbSubIntestazioneDishRow() -> some View {
        
        let (price,count) = csIterateDishPricing()
        // add 21.09
        let moneyCode = Locale.current.currency?.identifier ?? "EUR"
        let priceDouble = Double(price) ?? 0
     
     
        HStack(alignment:.center,spacing: 3) {
            
           // let percorso = self.item.percorsoProdotto
            
            if self.item.percorsoProdotto != .prodottoFinito {
              
                vbReviewLine()
            } else {
                Text(self.item.percorsoProdotto.simpleDescription().lowercased())
                    .italic()
                    .fontWeight(.semibold)
                    .foregroundColor(.seaTurtle_2)
            }
           
            Spacer()
            
            HStack(alignment:.top,spacing:1) {
              //  Text("€ \(price)") // 21.09
                Text("\(priceDouble,format: .currency(code: moneyCode))")
                    .fontWeight(.bold)
                    .font(.title3)
                    .foregroundColor(.seaTurtle_4)
                
                Text("+\(count)")
                    .fontWeight(.bold)
                    .font(.caption2)
                    .foregroundColor(.seaTurtle_3)
            }
            
            
        }
       .font(.subheadline)
        
    }

    @ViewBuilder private func vbReviewLine() -> some View {
        
        let (mediaRating,ratingCount,_) = self.item.ratingInfo(readOnlyViewModel: viewModel)
        
        Group {
            Text("\(mediaRating,specifier: "%.1f")") // media
                .fontWeight(.light)
                .foregroundColor(.seaTurtle_1)
                .padding(.horizontal,5)
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color.seaTurtle_2)
                )

            Group {
                Text("/")
                Text("\(ratingCount) recensioni") // valore da importare
                    .italic()
            }
            .fontWeight(.semibold)
            .foregroundColor(.seaTurtle_2)
        }
        
    }
    
    private func csIterateDishPricing() -> (price:String,count:String) {
        
        var mandatoryPrice:String = "0.00"
        let pricingCount = self.item.pricingPiatto.count
        let normalizedCount = pricingCount > 0 ? (pricingCount - 1) : pricingCount
        let stringCount:String = String(normalizedCount)
        
        guard !self.item.pricingPiatto.isEmpty else {
          
            return (mandatoryPrice,stringCount)
        }
            
            for format in self.item.pricingPiatto {
                
                if format.type == .mandatory {
                    mandatoryPrice = format.price
                    break
                }
               
            }

            return (mandatoryPrice,stringCount)
            
    }
    
    @ViewBuilder private func vbDieteCompatibili() -> some View {
        
        let dietAvaible = self.item.returnDietAvaible(viewModel: self.viewModel).inDishTipologia
        
        HStack(spacing: 4.0) {
            
            Image(systemName: "person.fill.checkmark")
                .imageScale(.medium)
                .foregroundColor(.seaTurtle_4)
         
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack(spacing: 2.0) {
                    
                    ForEach(dietAvaible,id:\.self) { diet in
                        
                        
                        CSEtichetta(
                            text: diet.simpleDescription(),
                            fontStyle: .subheadline,
                            fontWeight: .black,
                            fontDesign: .default,
                            textColor: .seaTurtle_1,
                            image: "checkmark.circle.fill",
                            imageColor: .blue,
                            imageSize: .medium,
                            backgroundColor: diet.coloreAssociato(),
                            backgroundOpacity: 0.8)
                        
                       /* Text(diet)
                            .font(.subheadline)
                            .fontWeight(.black)
                            .foregroundColor(.seaTurtle_4)
                        
                        Text("•")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.seaTurtle_4) */

                    }
                }
            }
        }
    }
    
    @ViewBuilder private func vbDescriptionScrollRow() -> some View {
        
        HStack(spacing:4) {
            
            Image(systemName: "list.bullet.rectangle")
                .imageScale(.medium)
                .foregroundColor(.seaTurtle_3)
            
            ScrollView(.horizontal,showsIndicators: false) {
                Text(self.item.descrizione)
                    .font(.headline)
                    .italic()
                    .foregroundColor(Color.black)
                    .opacity(0.6)
            }
        }
    }
    
    @ViewBuilder private func vbIngredientScrollRow() -> some View {
 
        let allFilteredIngredients = self.item.allMinusArchiviati(viewModel: self.viewModel)
     
            HStack(spacing: 4.0) {
   
                    Image(systemName: "list.bullet.rectangle")
                        .imageScale(.medium)
                        .foregroundColor(.seaTurtle_4)
  
                if !allFilteredIngredients.isEmpty {
                    
                    ScrollView(.horizontal,showsIndicators: false) {
                        
                        HStack(alignment:.lastTextBaseline, spacing: 2.0) {
                            
                            ForEach(allFilteredIngredients) { ingredient in
                                
                                let (isPrincipal,hasAllergene,isTemporaryOff,idSostituto,isBio) = self.analizingIngredient(ingredient: ingredient)
                                
                               HStack(spacing:5) {
                                    
                                   Text(ingredient.intestazione)
                                        .font(isPrincipal ? .headline : .subheadline)
                                        .foregroundColor(isTemporaryOff ? .seaTurtle_1 : .seaTurtle_4)
                                        .strikethrough(isTemporaryOff, color: Color.gray)
                                        .underline(isBio, pattern: .solid, color: Color.green)
                                        .overlay(alignment:.topTrailing) {
                                            if hasAllergene {
                                                Text("*")
                                                    .foregroundColor(Color.black)
                                                    .offset(x: 5, y: -3)
                                            }
                                        }

                                   if idSostituto != nil {
                                        
                                       let (isActive,name,allergeniIn) = self.viewModel.infoFromId(id: idSostituto!, modelPath: \.allMyIngredients)
                                       
                                       if isActive {
                                           
                                           Text("(\(name))")
                                               .font(isPrincipal ? .headline : .subheadline)
                                               .foregroundColor(.seaTurtle_3)
                                               .overlay(alignment:.topTrailing) {
                                                   if allergeniIn {
                                                       Text("*")
                                                           .foregroundColor(Color.black)
                                                           .offset(x: 5, y: -3)
                                                   }
                                               }
                                       }
                                       
                                        
                                    }

                                }
                                
                                Text("•")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.seaTurtle_4)
               
                            }
                        }
                    }
                } else {
                    
                    Text("Lista Ingredienti Vuota")
                        .italic()
                        .font(.headline)
                        .foregroundColor(.seaTurtle_1)
                    Spacer()
                }
                
            }
       // }
    }
    
    private func analizingIngredient(ingredient:IngredientModel) -> (isPrincipal:Bool,hasAllergene:Bool,isTemporary:Bool,idSostituto:String?,isBio:Bool) {
        
        let allTemporaryOff = self.item.elencoIngredientiOff
        
        let isPrincipal = self.item.ingredientiPrincipali.contains(ingredient.id)
       // let hasAllergene = !ingredient.allergeni.isEmpty
        let hasAllergene:Bool = {
            if let allergens = ingredient.allergeni {
                return !allergens.isEmpty
            } else { return false }
        }()
        let isItBio = ingredient.produzione == .biologico
        // Modifiche 30.08
        
       // let isOff = allTemporaryOff.keys.contains(ingredient.id)
        var isOff: Bool = false
        
        if self.item.idIngredienteDaSostituire == ingredient.id {isOff = true}
      //  else { isOff = ingredient.status == .completo(.inPausa) }
        else { isOff = ingredient.status.checkStatusTransition(check: .inPausa) }
       // let isOff = ingredient.status == .completo(.inPausa)
        var idSostituto: String? = nil
        
      //  var isThereSosti: Bool = false
      //  var nomeSosti: String = ""
        
        if isOff {
            
            for (key,value) in allTemporaryOff {
                
                if ingredient.id == key {
                    // Modifica 02.09
                    let isAlreadyIn = self.item.checkIngredientsInPlain(idIngrediente: value)
                    idSostituto = isAlreadyIn ? nil : value
                    // end - Vedi Nota Vocale 02.09 - bug "Menta(Mango)" 
                    break
                }
                
               /* if ingredient.id == key && value != nil {
                    isThereSosti = true
                    nomeSosti = self.viewModel.nomeIngredienteFromId(id: value!) ?? ""
                    break
                } */
                
            }
        }
        
        return (isPrincipal,hasAllergene,isOff,idSostituto,isItBio)
        // end 30.08

    }
    
    /*
    private func analizingIngredient(ingredient:IngredientModel) -> (isPrincipal:Bool,hasAllergene:Bool,isTemporary:Bool,isThereSostituto:Bool,nomeSostituto:String) {
        
        let allTemporaryOff = self.item.elencoIngredientiOffDEPRECATO
        
        let isPrincipal = self.item.ingredientiPrincipaliDEPRECATO.contains(ingredient)
        let hasAllergene = !ingredient.allergeni.isEmpty
            
        let isOff = allTemporaryOff.keys.contains(ingredient.id)
        var isThereSosti: Bool = false
        var nomeSosti: String = ""
        
        if isOff {
            
            for (key,value) in allTemporaryOff {
                
                if ingredient.id == key && value != nil {
                    isThereSosti = true
                    nomeSosti = value!.intestazione
                    break
                }
                
            }
        }
        
        return (isPrincipal,hasAllergene,isOff,isThereSosti,nomeSosti)
       
        
        
      /*  let (isTemporaryOff,isThereSostituto,nameSostituto):(Bool,Bool,String) = {
                
            guard allTemporaryOff.keys.contains(ingredient.id) else {
               return (false,false,"")
            }
            
            if let modelSostituto = allTemporaryOff[ingredient.id] {
                let nomeSostituto = modelSostituto!.intestazione
                return (true,true,nomeSostituto)
           
            } else {
                return(true,false,"")
            }

            
            }() */
        
        
    } */ // Deprecata 26.08
    
    /*
    @ViewBuilder private func vbIngredientScrollRow() -> some View {
        
        let allTheIngredients = self.item.ingredientiPrincipali + self.item.ingredientiSecondari
        let allTemporaryOff = self.item.sostituzioneIngredientiTemporanea
        
      //  VStack {

            HStack(spacing: 4.0) {
                
                Image(systemName: "list.bullet.rectangle")
                    .imageScale(.medium)
                    .foregroundColor(Color.seaTurtle_4)
             
                ScrollView(.horizontal,showsIndicators: false) {
                    
                    HStack(alignment:.lastTextBaseline, spacing: 2.0) {
                        
                        ForEach(allTheIngredients) { ingredient in
                            
                        let isPrincipal = self.item.ingredientiPrincipali.contains(ingredient)
                        let hasAllergene = !ingredient.allergeni.isEmpty
                            
                        let (isTemporaryOff,isThereSostituto,nameSostituto):(Bool,Bool,String) = {
                                
                            guard allTemporaryOff.keys.contains(ingredient.id) else {
                               return (false,false,"")
                            }
                            var nomeSostituto = allTemporaryOff[ingredient.id]!
                            let isSostituto = nomeSostituto != ""
                            if isSostituto {
                                nomeSostituto = self.viewModel.findModelFromId(id: nomeSostituto)
                            }
                            return (true,isSostituto,nomeSostituto)
                            }()
                            
                           HStack(spacing:5) {
                                
                                Text(ingredient.intestazione)
                                    .font(isPrincipal ? .headline : .subheadline)
                                    .foregroundColor(isTemporaryOff ? Color.seaTurtle_1 : Color.seaTurtle_4)
                                    .strikethrough(isTemporaryOff, color: Color.gray)
                                    .overlay(alignment:.topTrailing) {
                                        if hasAllergene {
                                            Text("*")
                                                .foregroundColor(Color.black)
                                                .offset(x: 5, y: -3)
                                        }
                                    }
                                
                                if isTemporaryOff && isThereSostituto {
                                    
                                    Text("(\(nameSostituto))")
                                        .font(isPrincipal ? .headline : .subheadline)
                                        .foregroundColor(Color.seaTurtle_3)
                                }
    
                            }
                            
                            Text("•")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.seaTurtle_4)
           
                        }
                    }
                }
            }
       // }
    } */ // deprecata 11.08
    
    
   /* @ViewBuilder private func vbIngredientScrollRow() -> some View {
        
        let allTheIngredients = self.item.ingredientiPrincipali + self.item.ingredientiSecondari
        
      //  VStack {

            HStack(spacing: 4.0) {
                
                Image(systemName: "list.bullet.rectangle")
                    .imageScale(.medium)
                    .foregroundColor(Color.seaTurtle_4)
             
                ScrollView(.horizontal,showsIndicators: false) {
                    
                    HStack(alignment:.lastTextBaseline, spacing: 2.0) {
                        
                        ForEach(allTheIngredients) { ingredient in
                            
                            let isPrincipal = self.item.ingredientiPrincipali.contains(ingredient)
                            let hasAllergene = !ingredient.allergeni.isEmpty
                            let isSelected = ingredient.id == idSelectedIngredient
                            let isThereSostituto: Bool = nomeIngredienteSostituto != ""
                            
                            HStack(spacing:5) {
                                
                                Text(ingredient.intestazione)
                                    .font(isPrincipal ? .headline : .subheadline)
                                    .foregroundColor(isSelected ? Color.blue : Color.seaTurtle_4)
                                    .strikethrough(isSelected && isThereSostituto, color: Color.gray)
                                    .overlay(alignment:.topTrailing) {
                                        if hasAllergene {
                                            Text("*")
                                                .foregroundColor(Color.black)
                                                .offset(x: 5, y: -3)
                                        }
                                    }
                                
                                if isSelected && isThereSostituto {
                                    
                                    Text("\(nomeIngredienteSostituto)")
                                        .font(isPrincipal ? .headline : .subheadline)
                                        .foregroundColor(Color.seaTurtle_3)
                                }
    
                            }
                            
                            Text("•")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.seaTurtle_4)
           
                        }
                    }
                }
            }
       // }
    }*/ //BackUp 08.08
    
    
    
} // chiusa Struct

struct DishModel_RowView_Previews: PreviewProvider {
    
    static var viewModel:AccounterVM = AccounterVM()
        
    static let ing1 = IngredientModel(intestazione: "Guanciale", descrizione: "", conservazione: .congelato, produzione: .biologico, provenienza: .italia, allergeni: [], origine: .animale, status: .completo(.disponibile))
        
    static let ing2 = IngredientModel(intestazione: "Prezzemolo", descrizione: "", conservazione: .congelato, produzione: .convenzionale, provenienza: .restoDelMondo, allergeni: [.sedano], origine: .vegetale, status: .completo(.inPausa))
    
    static let ing3 = IngredientModel(intestazione: "Latte Scremato", descrizione: "", conservazione: .altro, produzione: .biologico, provenienza: .europa, allergeni: [.latte_e_derivati], origine: .animale, status: .bozza())
    
    static let ing4 = IngredientModel(intestazione: "Basilico", descrizione: "", conservazione: .altro, produzione: .biologico, provenienza: .europa, allergeni: [.senape], origine: .vegetale, status: .completo(.disponibile))
    
    static var dishSample = {
       
        var dish = DishModel()
        dish.intestazione = "Spaghetti alla Carbonara"
        dish.status = .completo(.disponibile)
        dish.descrizione = "Piatto della tradizione romanesca con uova di galline della nonna Anna"
      /*  dish.rating = [
            DishRatingModel(voto: "5.7", titolo: "", commento: ""),DishRatingModel(voto: "6.7", titolo: "", commento: ""),DishRatingModel(voto: "8.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: "")
        ] */
        
        let price = {
           var priceFirst = DishFormat(type: .mandatory)
            priceFirst.price = "12.5"
            return priceFirst
        }()
        
        dish.pricingPiatto = [price]
        dish.ingredientiPrincipali = [ing1.id,ing2.id]
        dish.ingredientiSecondari = [ing3.id]
        dish.elencoIngredientiOff = [ing2.id:ing4.id]
        
        
        return dish
    }()
    static var dishSample2 = {
       
        var dish = DishModel()
        dish.intestazione = "Gin Tonic"
        dish.status = .completo(.disponibile)
      /*  dish.rating = [
            DishRatingModel(voto: "5.7", titolo: "", commento: ""),DishRatingModel(voto: "6.7", titolo: "", commento: ""),DishRatingModel(voto: "8.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: "")
        ] */
        
        let price1 = {
           var priceFirst = DishFormat(type: .opzionale)
            priceFirst.label = "Monkey"
            priceFirst.price = "14.5"
            return priceFirst
        }()
        let price2 = {
           var priceFirst = DishFormat(type: .opzionale)
            priceFirst.label = "Mare"
            priceFirst.price = "9.5"
            return priceFirst
        }()
        let price3 = {
           var priceFirst = DishFormat(type: .mandatory)
            priceFirst.label = "Bombay"
            priceFirst.price = "4.9"
            return priceFirst
        }()
        
        dish.pricingPiatto = [price1,price2,price3]
        dish.ingredientiPrincipali = [ing1.id,ing4.id]
        dish.ingredientiSecondari = [ing2.id,ing3.id]
        dish.percorsoProdotto = .preparazioneBeverage
      /*  dish.dieteCompatibili = TipoDieta.returnDietAvaible(ingredients: [ing1,ing2,ing3,ing4]).inDishTipologia */
        
        return dish
    }()
    static var dishSample3 = {
       
        var dish = DishModel()
        dish.intestazione = "Tagliere Locale"
        
        let price1 = {
           var priceFirst = DishFormat(type: .mandatory)
            priceFirst.label = "Piccolo"
            priceFirst.price = "4.0"
            return priceFirst
        }()
        let price2 = {
           var priceFirst = DishFormat(type: .opzionale)
            priceFirst.label = "Grande"
            priceFirst.price = "7.5"
            return priceFirst
        }()
        dish.status = .completo(.disponibile)
        dish.pricingPiatto = [price1,price2]
        dish.percorsoProdotto = .composizione
        dish.ingredientiPrincipali = [dish.id]
        dish.descrizione = "Salumi e Formaggi Locali"
       // dish.ingredientiPrincipali = [ing3.id]
      //  dish.ingredientiSecondari = [ing1.id,ing2.id,ing4.id]
    
        
        return dish
    }()
    
    static var dishSample4 = {
       
        var dish = DishModel()
        dish.intestazione = "CocaCola"
       /* dish.rating = [
            DishRatingModel(voto: "5.7", titolo: "", commento: ""),DishRatingModel(voto: "6.7", titolo: "", commento: ""),DishRatingModel(voto: "8.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: ""),DishRatingModel(voto: "9.7", titolo: "", commento: "")
        ] */
        
        let price1 = {
           var priceFirst = DishFormat(type: .mandatory)
            priceFirst.label = "Mezza Pinta"
            priceFirst.price = "4.0"
            return priceFirst
        }()
        let price2 = {
           var priceFirst = DishFormat(type: .opzionale)
            priceFirst.label = "Pinta"
            priceFirst.price = "7.5"
            return priceFirst
        }()
    
        dish.status = .completo(.disponibile)
        dish.pricingPiatto = [price1,price2]
        dish.ingredientiPrincipali = [dish.id]
        dish.percorsoProdotto = .prodottoFinito
        

        return dish
    }()
    
    
    static var previews: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color.seaTurtle_1.ignoresSafeArea()
                
                VStack {

                    
                    ScrollView {
                        VStack(spacing:10) {
                            Group {
                                DishModel_RowView(item: dishSample)
                                    .overlay {
                                        CS_VelaShape()
                                        .foregroundColor(Color.black)
                                        .cornerRadius(15.0)
                                        .opacity(0.8)
                                    }
                                
                                DishModel_RowView(item: dishSample, rowSize: .ridotto)
                                    .overlay {
                                        CS_VelaShape()
                                        .foregroundColor(Color.seaTurtle_4)
                                        .cornerRadius(15.0)
                                        .opacity(0.8)
                                    }
                                DishModel_RowView(item: dishSample, rowSize: .sintetico)
                                    .overlay {
                                        CS_VelaShape()
                                        .foregroundColor(Color.black)
                                        .cornerRadius(15.0)
                                        .opacity(0.8)
                                    }
                            }
                              //  .frame(height:150)
                            Group {
                                DishModel_RowView(item: dishSample2)
                                DishModel_RowView(item: dishSample2,rowSize: .ridotto)
                                DishModel_RowView(item: dishSample2,rowSize: .sintetico)
                            }
                               // .frame(height:150)
                            Group {
                                DishModel_RowView(item: dishSample3)
                                DishModel_RowView(item: dishSample3,rowSize: .ridotto)
                                DishModel_RowView(item: dishSample3,rowSize: .sintetico)
                            }
                               // .frame(height:150)
                            Group {
                                DishModel_RowView(item: dishSample4)
                                DishModel_RowView(item: dishSample4,rowSize: .ridotto)
                                DishModel_RowView(item: dishSample4,rowSize: .sintetico)
                            }
                               // .frame(height:150)
                            
                           
                        }
                    }
          
                }
                
            }
            
        }
        .onAppear{
            viewModel.allMyIngredients = [ing1,ing2,ing3,ing4]
        }
        .environmentObject(viewModel)
        
    }
}


