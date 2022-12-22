//
//  TopBar_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 28/02/22.
//

import SwiftUI
import MyPackView_L0

/*struct TopBar_NewDishSubView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var newDish: DishModel
    @Binding var wannaAddIngredient: Bool?
  //  @Binding var openAddingIngredienteSecondario: Bool?
    @Binding var wannaCreateIngredient: Bool?
    @Binding var wannaDeleteIngredient: Bool
    
    var body: some View {
        HStack { // una Sorta di NavigationBar
            
            Text(newDish.name != "" ? newDish.name : "New Dish")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.black)
            
            Spacer()
            
            // Done Button
            
            if wannaAddIngredient! {
                
                CSButton_tight(title: "Done", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.blue) {
                    self.wannaAddIngredient = false
                  //  self.openAddingIngredienteSecondario = false
                }
                
            }
            
            // Exit NuovoIngrediente
            
            else if wannaCreateIngredient!  {
                
                CSButton_tight(title: "Exit", fontWeight: .semibold, titleColor: Color.red, fillColor: Color.clear) {
                    self.wannaCreateIngredient = false
                }
                
                
            }
            
            // Delete Button
            
            else if wannaDeleteIngredient {
                
                CSButton_tight(title: "Annulla", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.red) {
                    self.wannaDeleteIngredient = false
                }
                
            }
            
            // Default Button
            
            else {
                
                CSButton_tight(title: "Dismiss", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.clear) { dismiss() }
            }
            
        }
        
    }
} */

/*struct TopBar_NewDishSubView_Previews: PreviewProvider {
    static var previews: some View {
        TopBar_NewDishSubView()
    }
} */

struct TopBar_3BoolPlusDismiss: View {
    
    @Environment(\.dismiss) var dismiss
    
    let title: String
    let customDoneButtonTitle: String
    @Binding var doneButton: Bool?
    let customExitButtonTitle:String
    @Binding var exitButton: Bool?
    let customCancelButtonTitle: String
    @Binding var cancelButton: Bool?
    var enableEnvironmentDismiss:Bool // Non è binding perchè il suo valore non viene mutato, ma serve ad attivare il dismiss dall'enviroment
    
    init(title: String, enableEnvironmentDismiss: Bool? = nil, doneButton: Binding<Bool?>? = nil, doneButtonTitle:String? = nil, exitButton: Binding<Bool?>? = nil,exitButtonTitle:String? = nil, cancelButton: Binding<Bool?>? = nil, cancelButtonTitle:String? = nil) {
        
        self.title = title
        self.enableEnvironmentDismiss = enableEnvironmentDismiss ?? false
        _doneButton = doneButton ?? .constant(nil)
        _exitButton = exitButton ?? .constant(nil)
        _cancelButton = cancelButton ?? .constant(nil)
        
        self.customDoneButtonTitle = doneButtonTitle ?? "Fatto"
        self.customExitButtonTitle = exitButtonTitle ?? "Esci"
        self.customCancelButtonTitle = cancelButtonTitle ?? "Indietro"
    }
    
    var body: some View {
        
        HStack { // una Sorta di NavigationBar

            Text(title)
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.black)
            
            Spacer()
            
            // Done Button
            
            if doneButton != nil && doneButton == true {
                
                CSButton_tight(title: customDoneButtonTitle, fontWeight: .semibold, titleColor: Color.white, fillColor: Color.blue) {
                    self.doneButton = false
                  //  self.openAddingIngredienteSecondario = false
                }
            }
            
            // Exit NuovoIngrediente
            
            else if exitButton != nil && exitButton == true {
                
                CSButton_tight(title: customExitButtonTitle, fontWeight: .semibold, titleColor: Color.red, fillColor: Color.clear) {
                    self.exitButton = false
                }
            }
            
            // Delete Button
            
            else if cancelButton != nil && cancelButton == true {
                
                CSButton_tight(title: customCancelButtonTitle, fontWeight: .semibold, titleColor: Color.blue, fillColor: Color.clear) {
                    self.cancelButton = false
                }
            }
            
            // Default Button
            
            else if enableEnvironmentDismiss {
                
                CSButton_tight(title: "Dismiss", fontWeight: .semibold, titleColor: Color.white, fillColor: Color.clear) { dismiss() }
            }
            
            else {EmptyView()}
            
        }
        
    }
}
