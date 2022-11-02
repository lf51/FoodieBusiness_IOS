//
//  MonitorGenerale.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/10/22.
//

import SwiftUI
/*
struct MonitorGenerale: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    var body: some View {
        
        CSZStackVB_Framed(frameWidth:500,backgroundOpacity: 0.08,shadowColor: .clear)
            {
            
                vbServizioStat()
                    .padding(.horizontal,5)
            
            
        }

    }
    
    // Method
    
    private func checkStatus<M:MyProStatusPack_L0>(path:KeyPath<AccounterVM,[M]>,filter:[DishModel.PercorsoProdotto]?) -> (all:Int,disponibili:Int,inPausa:Int,archivio:Int) {
        
        let model = self.viewModel[keyPath: path]
        var cleanModel = model.filter({
            $0.status != .bozza()
        }) // per non considerare gli ingredienti di Sistema e/o eventuali errori che salvano bozze(nil)
        
        if let filtro = filter {
            
            let newModel = cleanModel as! [DishModel]
            let filteredModel = newModel.filter({
                filtro.contains($0.percorsoProdotto)
            })
            cleanModel = filteredModel as! [M]
            
        }
        
        let all = cleanModel.count
        
        let statusMap = cleanModel.map({$0.status})
        
        let disponibili = statusMap.filter({$0.checkStatusTransition(check: .disponibile)}).count
        let inPausa = statusMap.filter({$0.checkStatusTransition(check: .inPausa)}).count
        let archiviati = statusMap.filter({$0.checkStatusTransition(check: .archiviato)}).count
        
        return (all,disponibili,inPausa,archiviati)
    }
 
    private func checkInventario<M:MyProStatusPack_L1>(path:KeyPath<AccounterVM,[M]>,filter:DishModel.PercorsoProdotto?) -> (all:Int,inStock:Int,inArrivo:Int, inEsauri:Int,esaurite:Int) {
        
        let model = self.viewModel[keyPath: path]
        var cleanModel = model.filter({
            $0.status != .bozza()
        })
        
        if let filtro = filter {
            
            let newModel = cleanModel as! [DishModel]
            let filteredModel = newModel.filter({
                $0.percorsoProdotto == filtro
            })
            cleanModel = filteredModel as! [M]
            
        }
        
        let all = cleanModel.count
       
        let allMapped = cleanModel.map({
            self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id)
        })
        
        let inStock = allMapped.filter({$0 == .inStock}).count
        let inArrivo = allMapped.filter({$0 == .inArrivo}).count
        let inEsauri = allMapped.filter({$0 == .inEsaurimento}).count
        let esaurite = allMapped.filter({$0 == .esaurito}).count
        
        return (all,inStock,inArrivo,inEsauri,esaurite)
    }
    
    
    @ViewBuilder private func vbSingleModelInfo<M:MyProStatusPack_L0>(label:String,path:KeyPath<AccounterVM,[M]>,filterCollection:[DishModel.PercorsoProdotto]? = nil) -> some View {
        
        let(all,dispo,inP,arch) = self.checkStatus(path: path,filter: filterCollection)
        
        let allDouble = Double(all)
        let dispoPercent = Double(dispo) / allDouble
        let stringDispo100 = String(format:"%.1f%%",(dispoPercent * 100))
        let inPausaPercent = Double(inP) / allDouble
        let stringInP100 = String(format:"%.1f%%",(inPausaPercent * 100))
        let archPercent = Double(arch) / allDouble
        let stringArch100 = String(format:"%.1f%%",(archPercent * 100))
        
        VStack(alignment:.leading,spacing:2) {
            
            HStack {
                Text(label)
                    .fontWeight(.semibold)
                Text("\(all)")
                    .fontWeight(.bold)
            }
            .foregroundColor(Color.black)
            
            HStack {
                Text("Distribuzione per Status:")
               
            }
            
            GeometryReader { geometry in
                
                let sizeView = geometry.size.width

                    HStack(spacing:0) {
                        
                        Text("\(dispo)(\(stringDispo100))")
                            .fontWeight(.bold)
                            .frame(width:(sizeView * dispoPercent))
                            .background{
                                StatusTransition.colorAssociated(.disponibile)()
                                    
                            }
                            .cornerRadius(5.0)
                        
                        Text("\(inP)(\(stringInP100))")
                            .fontWeight(.bold)
                            .frame(width:(sizeView * inPausaPercent))
                            .background{
                                StatusTransition.colorAssociated(.inPausa)()
                                    
                            }
                            .cornerRadius(5.0)
                       
                        Text("\(arch)(\(stringArch100))")
                            .fontWeight(.bold)
                            .frame(width: (sizeView * archPercent))
                            .background{
                                StatusTransition.colorAssociated(.archiviato)()
                                    
                            }
                            .cornerRadius(5.0)
                    }
                    .foregroundColor(Color.black)

            } .frame(height: 25)
      
        }
    }
    
    @ViewBuilder private func vbInfoInventario<M:MyProStatusPack_L1>(path:KeyPath<AccounterVM,[M]>,filter:DishModel.PercorsoProdotto? = nil) -> some View {

        let(all,inStock,inArrivo,inEsauri,esaurite) = self.checkInventario(path: path, filter: filter)
        
        let allDouble = Double(all)

        let stockPercent = Double(inStock) / allDouble
        let stringStock100 = String(format:"%.1f%%",(stockPercent * 100))

        let inArrivoPercent = Double(inArrivo) / allDouble
        let stringArrivo100 = String(format:"%.1f%%",(inArrivoPercent * 100))
        
        let inEsauriPercent = Double(inEsauri) / allDouble
        let stringInEsauri100 = String(format:"%.1f%%",(inEsauriPercent * 100))
        
        let esauritePercent = Double(esaurite) / allDouble
        let stringEsaurite100 = String(format:"%.1f%%",(esauritePercent * 100))

        VStack(alignment:.leading,spacing:2.0) {
            
            Text("Livello Scorte:")

            HStack {
                Text(stringStock100)
                Text("in Stock")
                        .italic()
                }
            
            HStack {
                Text(stringArrivo100)
                Text("in arrivo")
                    .italic()
            }
            
            HStack {
                Text(stringInEsauri100)
                Text("in Esaurimento")
                    .italic()
            }
            
            HStack {
                Text(stringEsaurite100)
                Text("esaurite")
                    .italic()
            }
        
        }
      
        
    }
    
    @ViewBuilder private func vbServizioStat() -> some View {
                        
        VStack(alignment:.leading) {
            
            HStack {
                
                Text("Monitor Attività")
                    .font(.system(.headline, design: .monospaced, weight: .black))
                    .foregroundColor(Color("SeaTurtlePalette_4"))
                
                   Spacer()

            }
            .padding(.vertical,5)

            vbSingleModelInfo(label: "Menu:", path: \.allMyMenu)
            Divider()
            vbSingleModelInfo(label: "Preparazioni(F&B):", path: \.allMyDish,filterCollection: [.preparazioneBeverage,.preparazioneFood])
            Divider()
            VStack(alignment:.leading, spacing:0) {
                
                vbSingleModelInfo(label: "Ingredienti:", path: \.allMyIngredients)
                vbInfoInventario(path: \.allMyIngredients)
            }
            Divider()
            VStack(alignment:.leading, spacing:0)  {
                vbSingleModelInfo(label: "Preparati:", path: \.allMyDish,filterCollection: [.prodottoFinito])
                vbInfoInventario(path: \.allMyDish,filter: .prodottoFinito)

            }
        }
        .font(.system(.subheadline, design: .monospaced))
    }
}

struct MonitorGenerale_Previews: PreviewProvider {
    static var previews: some View {
        MonitorGenerale()
    }
}
*/ // 25.10 Deprecato - Va eventualmente messo a parte, e non nella home, ma comunque mi sembra inutile. Possiamo dare le informazioni di ciascun Model nella lista generale di ognuno.
