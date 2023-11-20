//
//  ProductModel_RowView.swift
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
    case fromSharedLibrary
  //  case ibrido(_ limitedTo:CGFloat? = nil)
    
    func returnType() -> RowSize {
        
        switch self {
        case .sintetico:
            return .sintetico
        case .ridotto:
            return .ridotto
        case .normale(_):
            return .normale()
        case .fromSharedLibrary:
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
        case .fromSharedLibrary:
            return 300
        case .normale(let width):
            return width
            
       /* case .ibrido(let width):
            return width */

        }
        
    }
    
}

struct ProductModel_RowView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let item: ProductModel
    let rowSize:RowSize
    
    @State private var showDescription:Bool = false
    
    init(item: ProductModel, rowSize: RowSize = .normale()) {
        
        self.item = item
        self.rowSize = rowSize

    }
    
    var body: some View { vbSwitchRowSize() }
    
    // View da Switchare
    
    @ViewBuilder private func vbSwitchRowSize() -> some View {
        
        switch rowSize {
            
        case .sintetico:
            vbSinteticRow()
        case .ridotto:
            vbSmallRow()
        default:
        //case .normale:
            vbNormalRow()
       /* case .ibrido:
           vbIbridoRow() */
        }
    }
    
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
        
        /*let percorsoIbrido:Bool = {
            let percorsoProdotto = item.percorsoProdotto.returnTypeCase()
            
           return percorsoProdotto == .composizione() ||
            percorsoProdotto == .finito()
        }()*/
        
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
                    //else if percorsoIbrido { vbIngredientQuality() }
                   // else { vbIngredientScrollRow() }
                    else {
                        
                       vbIngredientAdress()
                    }
                    
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
                    .foregroundStyle(Color.yellow)
                Text("del Giorno")
                    .bold()
                    .font(.caption)
                    .foregroundStyle(Color.white)
                    
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
    
    @ViewBuilder private func vbIngredientAdress() -> some View {
        
        switch self.item.percorsoProdotto {
            
        case .preparazione:
            vbIngredientScrollRow()
        case .composizione(let ingredientModel):
            if let ingredientModel {  vbIngredientQuality(sottostante:ingredientModel) }
            else { Text("ERRORE_ING_SOTTOSTANTE")}
           
        case .finito(let string):
            if let string,
               let ingredient = self.viewModel.modelFromId(id: string, modelPath: \.db.allMyIngredients) { vbIngredientQuality(sottostante: ingredient) }
            else { Text("ERRORE_ING_SOTTOSTANTE") }
            
        }
    }
    /// solo per viewRow ibride
    @ViewBuilder private func vbIngredientQuality(sottostante:IngredientModel) -> some View {
        

        
       // if let modelDS = self.viewModel.modelFromId(id: self.item.id, modelPath: \.db.allMyIngredients) {
            
            let conservazione = sottostante.conservazione
            let origine = sottostante.origine
            let provenienza = sottostante.provenienza
            
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
            
            
            
       // }
        
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
        
        let isSottostanteARif:String? = {
           
         let sottostante = self.item.percorsoProdotto.associatedValue() as? String
                return sottostante
           
        }()
        let isNotDescribed = self.item.descrizione == nil
        
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
            
            if let rif = isSottostanteARif {
                
               // let sottostante = self.item.percorsoProdotto.associatedValue() as? String
                let statoScorte = self.viewModel.currentProperty.inventario.statoScorteIng(idIngredient: rif)
                
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
                
                    if isSottostanteARif == nil {
                        
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
        .foregroundStyle(Color.black)
    }
    
    @ViewBuilder private func vbIntestazioneDishRow() -> some View {
        
        let value:(font:Font,imageSize:Image.Scale) = {
           
            if self.rowSize.returnType() == .normale() { return (.title2,.medium)}
            else { return (.title3,.small)}
        }()
        
        let dashedColor:Color = {
            
            if let rif = self.item.percorsoProdotto.associatedValue() as? String {
                
               return self.viewModel.currentProperty.inventario.statoScorteIng(idIngredient: rif).coloreAssociato()
                
            }
            else {
                return self.item.checkStatusExecution(viewModel: self.viewModel).coloreAssociato()
            }
        }()
        
        let productType:ProductType = {
            
            if let categoria = self.viewModel.modelFromId(id: item.categoriaMenu, modelPath: \.db.allMyCategories) {
                return categoria.productType
            } else {
                return .food
            }
        }()
    
        let percorsoImage = self.item.percorsoProdotto.imageAssociated(to: productType)
        
        HStack(alignment:.center,spacing: 3) {
            
            Image(systemName: percorsoImage.system)
                .imageScale(value.imageSize)
                .foregroundStyle(percorsoImage.color)
            
            Text(self.item.intestazione)
                .font(value.font)
                .fontWeight(.semibold)
                .lineLimit(1)
                .allowsTightening(true)
                .foregroundStyle(Color.white)
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
            
            if self.item.percorsoProdotto.returnTypeCase() != .finito() {
              
                vbReviewLine()
            } else {
                Text(self.item.percorsoProdotto.simpleDescription().lowercased())
                    .italic()
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.seaTurtle_2)
            }
           
            Spacer()
            
            HStack(alignment:.top,spacing:1) {
              //  Text("€ \(price)") // 21.09
                Text("\(priceDouble,format: .currency(code: moneyCode))")
                    .fontWeight(.bold)
                    .font(.title3)
                    .foregroundStyle(Color.seaTurtle_4)
                
                Text("+\(count)")
                    .fontWeight(.bold)
                    .font(.caption2)
                    .foregroundStyle(Color.seaTurtle_3)
            }
            
            
        }
       .font(.subheadline)
        
    }

    @ViewBuilder private func vbReviewLine() -> some View {
        
        let (mediaRating,ratingCount,_) = self.item.ratingInfo(readOnlyViewModel: viewModel)
        
        Group {
            Text("\(mediaRating,specifier: "%.1f")") // media
                .fontWeight(.light)
                .foregroundStyle(Color.seaTurtle_1)
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
            .foregroundStyle(Color.seaTurtle_2)
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
                .foregroundStyle(Color.seaTurtle_4)
         
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
                            .foregroundStyle(Color.seaTurtle_4)
                        
                        Text("•")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.seaTurtle_4) */

                    }
                }
            }
        }
    }
    
    @ViewBuilder private func vbDescriptionScrollRow() -> some View {
        
        HStack(spacing:4) {
            
            Image(systemName: "list.bullet.rectangle")
                .imageScale(.medium)
                .foregroundStyle(Color.seaTurtle_3)
            
            ScrollView(.horizontal,showsIndicators: false) {
                Text(self.item.descrizione ?? "")
                    .font(.headline)
                    .italic()
                    .foregroundStyle(Color.black)
                    .opacity(0.6)
            }
        }
    }
    
    @ViewBuilder private func vbIngredientScrollRow() -> some View {
 
        let allFilteredIngredients = self.item.allMinusArchiviati(viewModel: self.viewModel)
     
            HStack(spacing: 4.0) {
   
                    Image(systemName: "list.bullet.rectangle")
                        .imageScale(.medium)
                        .foregroundStyle(Color.seaTurtle_4)
  
                if !allFilteredIngredients.isEmpty {
                    
                    ScrollView(.horizontal,showsIndicators: false) {
                        
                        HStack(alignment:.lastTextBaseline, spacing: 2.0) {
                            
                            ForEach(allFilteredIngredients) { ingredient in
                                
                                let (isPrincipal,hasAllergene,isTemporaryOff,idSostituto,isBio) = self.analizingIngredient(ingredient: ingredient)
                                
                               HStack(spacing:5) {
                                    
                                   Text(ingredient.intestazione)
                                        .font(isPrincipal ? .headline : .subheadline)
                                        .foregroundStyle(isTemporaryOff ? Color.seaTurtle_1 : Color.seaTurtle_4)
                                        .strikethrough(isTemporaryOff, color: Color.gray)
                                        .underline(isBio, pattern: .solid, color: Color.green)
                                        .overlay(alignment:.topTrailing) {
                                            if hasAllergene {
                                                Text("*")
                                                    .foregroundStyle(Color.black)
                                                    .offset(x: 5, y: -3)
                                            }
                                        }

                                   if idSostituto != nil {
                                        
                                       let (isActive,name,allergeniIn) = self.viewModel.infoFromId(id: idSostituto!, modelPath: \.db.allMyIngredients)
                                       
                                       if isActive {
                                           
                                           Text("(\(name))")
                                               .font(isPrincipal ? .headline : .subheadline)
                                               .foregroundStyle(Color.seaTurtle_3)
                                               .overlay(alignment:.topTrailing) {
                                                   if allergeniIn {
                                                       Text("*")
                                                           .foregroundStyle(Color.black)
                                                           .offset(x: 5, y: -3)
                                                   }
                                               }
                                       }
                                       
                                        
                                    }

                                }
                                
                                Text("•")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.seaTurtle_4)
               
                            }
                        }
                    }
                } else {
                    
                    Text("Lista Ingredienti Vuota")
                        .italic()
                        .font(.headline)
                        .foregroundStyle(Color.seaTurtle_1)
                    Spacer()
                }
                
            }
       // }
    }
    
    private func analizingIngredient(ingredient:IngredientModel) -> (isPrincipal:Bool,hasAllergene:Bool,isTemporary:Bool,idSostituto:String?,isBio:Bool) {
        
        let allTemporaryOff = self.item.elencoIngredientiOff ?? [:]
        let ingredientiPrincipali = self.item.ingredientiPrincipali ?? []
        let isPrincipal = ingredientiPrincipali.contains(ingredient.id)
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
    
  
    
   
    

    
    
    
} // chiusa Struct
/*
struct ProductModel_RowView_Previews: PreviewProvider {
    
   static let user = UserRoleModel(ruolo: .admin)
    
    static var viewModel:AccounterVM = AccounterVM(userManager: UserManager(userAuthUID: "TEST_USER_UID"))//AccounterVM(userAuth: user)
        
    static let ing1 = IngredientModel(intestazione: "Guanciale", descrizione: "", conservazione: .congelato, produzione: .biologico, provenienza: .italia, allergeni: [], origine: .animale, status: .completo(.disponibile))
        
    static let ing2 = IngredientModel(intestazione: "Prezzemolo", descrizione: "", conservazione: .congelato, produzione: .convenzionale, provenienza: .restoDelMondo, allergeni: [.sedano], origine: .vegetale, status: .completo(.inPausa))
    
    static let ing3 = IngredientModel(intestazione: "Latte Scremato", descrizione: "", conservazione: .altro, produzione: .biologico, provenienza: .europa, allergeni: [.latte_e_derivati], origine: .animale, status: .bozza())
    
    static let ing4 = IngredientModel(intestazione: "Basilico", descrizione: "", conservazione: .altro, produzione: .biologico, provenienza: .europa, allergeni: [.senape], origine: .vegetale, status: .completo(.disponibile))
    
    static var dishSample = {
       
        var dish = ProductModel()
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
       
        var dish = ProductModel()
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
        dish.percorsoProdotto = .preparazione
      /*  dish.dieteCompatibili = TipoDieta.returnDietAvaible(ingredients: [ing1,ing2,ing3,ing4]).inDishTipologia */
        
        return dish
    }()
    static var dishSample3 = {
       
        var dish = ProductModel()
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
        dish.percorsoProdotto = .composizione()
        dish.ingredientiPrincipali = [dish.id]
        dish.descrizione = "Salumi e Formaggi Locali"
       // dish.ingredientiPrincipali = [ing3.id]
      //  dish.ingredientiSecondari = [ing1.id,ing2.id,ing4.id]
    
        
        return dish
    }()
    
    static var dishSample4 = {
       
        var dish = ProductModel()
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
        dish.percorsoProdotto = .finito()
        

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
                                ProductModel_RowView(item: dishSample)
                                    .overlay {
                                        CS_VelaShape()
                                        .foregroundStyle(Color.black)
                                        .cornerRadius(15.0)
                                        .opacity(0.8)
                                    }
                                
                                ProductModel_RowView(item: dishSample, rowSize: .ridotto)
                                    .overlay {
                                        CS_VelaShape()
                                        .foregroundStyle(Color.seaTurtle_4)
                                        .cornerRadius(15.0)
                                        .opacity(0.8)
                                    }
                                ProductModel_RowView(item: dishSample, rowSize: .sintetico)
                                    .overlay {
                                        CS_VelaShape()
                                        .foregroundStyle(Color.black)
                                        .cornerRadius(15.0)
                                        .opacity(0.8)
                                    }
                            }
                              //  .frame(height:150)
                            Group {
                                ProductModel_RowView(item: dishSample2)
                                ProductModel_RowView(item: dishSample2,rowSize: .ridotto)
                                ProductModel_RowView(item: dishSample2,rowSize: .sintetico)
                            }
                               // .frame(height:150)
                            Group {
                                ProductModel_RowView(item: dishSample3)
                                ProductModel_RowView(item: dishSample3,rowSize: .ridotto)
                                ProductModel_RowView(item: dishSample3,rowSize: .sintetico)
                            }
                               // .frame(height:150)
                            Group {
                                ProductModel_RowView(item: dishSample4)
                                ProductModel_RowView(item: dishSample4,rowSize: .ridotto)
                                ProductModel_RowView(item: dishSample4,rowSize: .sintetico)
                            }
                               // .frame(height:150)
                            
                           
                        }
                    }
          
                }
                
            }
            
        }
        .onAppear{
            viewModel.db.allMyIngredients = [ing1,ing2,ing3,ing4]
        }
        .environmentObject(viewModel)
        
    }
}*/


