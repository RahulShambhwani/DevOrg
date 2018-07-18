public class VfAssignmentController{
    public Id contactId{get;set;}				// Store Contact Id
    public String selectedCategory{get;set;}	// Selected Category 
    public Contact selectedContact{get;set;}	// Selected Contact
    public List<Product2> selectedProdList{get;set;}
    public Map<Id,Product2> addtoCartProdMap{get;set;}
    Public Boolean itemAlreadyInCart{get;set;}
    public Decimal totalAmount{get;set;}
    public Decimal totalQuantity{get;set;}
    public String itemIdToBeRemove{get;set;}
    public Product2 itemToBeRemove{get;set;}
    
    public PurchaseSummeryItem__c purchaseItem{get;set;}
    public List<Purchase_Summary__c> purchaseSummaryList{get;set;}
    public Map<Id,PurchaseSummeryItem__c> purchaseSummaryItemMap{get;set;}
    public Set<String> purchaseSummaryItemNameSet{get;set;}
    public List<PurchaseSummeryItem__c> placeOrderItemList{get;set;}
    public Purchase_Summary__c purchaseSum{get;set;}
    
    public Map<Id,Product2> selectedProdMap=new Map<Id, Product2>();
    public String selectedItem{get;set;}
    public Product2 selectedProduct{get;set;}
    public String selectedProductId{get;set;}
    public Integer getQty{get;set;}
    public Integer totalProductAmount{get;set;}
    public String selectedProductIdOnQtyChange{get;set;}
    
    public List<SelectOption> productFamilyList{get;set;}
    public List<SelectOption> itemList{get;set;}
    
    
    public VfAssignmentController(){
        getQty=1;
        contactId=ApexPages.currentPage().getParameters().get('id');
        selectedContact=new Contact();
        productFamilyList=new List<SelectOption>();
        purchaseSummaryList= new List<Purchase_Summary__c>();
        purchaseSummaryItemNameSet= new Set<String>();
        itemList=new List<SelectOption>();
        selectedProdList= new List<Product2>();
        addtoCartProdMap= new Map<Id, Product2>();
        placeOrderItemList= new List<PurchaseSummeryItem__c>();
        purchaseSummaryItemMap=new Map<Id,PurchaseSummeryItem__c>();
        for(Contact con :[SELECT Name, Phone							// Contact display on page load
                          FROM Contact
                          WHERE Id =:contactId]){
                              selectedContact=con;
                          }
        
        for(Schema.PicklistEntry pe: product2.Family.getDescribe().getPicklistValues()){	// Product Family display on page load
            productFamilyList.add(new SelectOption(pe.getValue() , pe.getLabel()));
        }
        selectedCategory=null;
        selectedItem=null;
        selectedProdList.clear();
    }
    
    public void getItemList(){									// Display Item list related to category
        itemList.clear();
        
        selectedItem=null;
        
        itemList.add(new SelectOption('', '--None--'));
        for(Product2 product :[SELECT Id, Name, Family
                               FROM Product2
                               WHERE Family =:selectedCategory]){
                                   itemList.add(new SelectOption(product.Id, product.Name));
                               }
        
    }
    public void itemSummeryPanel(){		// Item Summary table display on item selection
        
        selectedProdList.clear();		// To clear add to cart table each time item selected
        System.debug(selectedItem);
        for(Product2 prod :[SELECT Name, Price__c, Family 
                            FROM Product2 
                            WHERE Id =:selectedItem]){
                                selectedProdList.add(prod);
                                selectedProdMap.put(prod.Id, prod);
                            }
        //System.debug(selectedProdList);
        
    }
    
    public void getAddToCartItemDetails(){						// Table display on click of add to cart 
        totalAmount=0;											// total Amount=0 each time
        totalQuantity=0;										// total Quantity=0 each time					
        selectedProduct=selectedProdMap.get(selectedProductId);	// Selected Product = Selected Item
        
        purchaseItem=new PurchaseSummeryItem__c();				
        purchaseItem.Product__c=selectedProductId;
        purchaseItem.Quantity__c=getQty;
        purchaseItem.Total__c= getQty * selectedProdMap.get(selectedProductId).Price__c;
        
        
        if(!purchaseSummaryItemNameSet.contains(selectedProduct.Name)){		// Add Item Name in purchaseSummaryItemNameSet if not contains
            purchaseSummaryItemMap.put(purchaseItem.Product__c, purchaseItem);		// Add Item in purchaseSummaryItemMap
            purchaseSummaryItemNameSet.add(selectedProduct.Name);
            itemAlreadyInCart = true;										// Now Item in cart 
            //System.debug('If');
        }
        else{
            //System.debug('Else');
            itemAlreadyInCart = false;											// If Item already in cart
            purchaseSummaryItemMap.get(purchaseItem.Product__c).Quantity__c++;	// add quantity by 1
            selectedProductIdOnQtyChange=purchaseItem.Product__c;
            getTotalOnQtyChanged();
        }
        
        
        if(!addtoCartProdMap.containsKey(purchaseItem.Product__c))
            addtoCartProdMap.put(purchaseItem.Product__c, selectedProduct);
        
        if(itemAlreadyInCart){
            for(PurchaseSummeryItem__c purchItem: purchaseSummaryItemMap.values()){
                totalAmount+=purchItem.Total__c;
                totalQuantity+=purchItem.Quantity__c;
            }
        }
        
        System.debug('Product >>>>>'+purchaseItem.Product__r.Price__c);
        
    }
    
    public void getTotalOnQtyChanged(){
        totalAmount=0;
        totalQuantity=0;
        																										// get Total amount
        totalProductAmount=Integer.valueOf(purchaseSummaryItemMap.get(selectedProductIdOnQtyChange).Quantity__c 
                                           * selectedProdMap.get(selectedProductIdOnQtyChange).Price__c);
        purchaseSummaryItemMap.get(selectedProductIdOnQtyChange).Total__c= totalProductAmount;

        if(purchaseSummaryItemMap.get(selectedProductIdOnQtyChange).Quantity__c==0){
            itemToBeRemove=selectedProdMap.get(selectedProductIdOnQtyChange);			// Get item to be remove
            purchaseSummaryItemNameSet.remove(itemToBeRemove.Name);			// Remove name from purchaseSummaryItemNameSet
            purchaseSummaryItemMap.remove(selectedProductIdOnQtyChange);
            if(purchaseSummaryItemMap.size()==0)
                selectedProductId=null;
        }
        
        
        for(PurchaseSummeryItem__c purchItem: purchaseSummaryItemMap.values()){
            totalAmount+=purchItem.Total__c;
            totalQuantity+=purchItem.Quantity__c;
        }
        
        System.debug(totalAmount+'>>>'+totalQuantity);
        System.debug(purchaseItem.Total__c);
    }
    
    public void removeItemFromCart(){
        itemToBeRemove=selectedProdMap.get(itemIdToBeRemove);			// Get item to be remove
        purchaseSummaryItemNameSet.remove(itemToBeRemove.Name);			// Remove name from purchaseSummaryItemNameSet
        //System.debug(purchaseSummaryItemMap.get(itemIdToBeRemove));		
        //System.debug(purchaseSummaryItemNameSet);
        purchaseSummaryItemMap.remove(itemIdToBeRemove);				// Remove Item from purchaseSummaryItemMap
        if(purchaseSummaryItemMap.size()==0)
            selectedProductId=null;
        totalAmount=0;
        totalQuantity=0;
        for(PurchaseSummeryItem__c purchItem: purchaseSummaryItemMap.values()){
            totalAmount+=purchItem.Total__c;
            totalQuantity+=purchItem.Quantity__c;
        }
    }
    
    public void placeOrderToCustomer(){
        purchaseSum=new Purchase_Summary__c();
        purchaseSum.Contact__c=contactId;
        if(purchaseSum.Total__c == null)
            purchaseSum.Total__c=0;
        if(purchaseSum.Total_Item__c == null)
            purchaseSum.Total_Item__c=0;
        
        purchaseSum.Total__c+=totalAmount;
        purchaseSum.Total_Item__c+=totalQuantity;
		insert purchaseSum;
        
        for(PurchaseSummeryItem__c purchaseSummItem: purchaseSummaryItemMap.values()){
            if(purchaseSummItem.Quantity__c >0){
                purchaseSummItem.Purchase_Summary__c=purchaseSum.Id;
                placeOrderItemList.add(purchaseSummItem);
            }
        }
        
        if(placeOrderItemList.size()>0)
            insert placeOrderItemList;
    }
    
    public void cancelOrder(){
        selectedCategory=null;
        selectedItem=null;
        selectedProductId=null;
        itemAlreadyInCart=false;
        totalAmount=0;
        totalQuantity=0;
        totalProductAmount=0;
        selectedProductIdOnQtyChange=null;
        addtoCartProdMap.clear();
        purchaseSummaryList.clear();
        purchaseSummaryItemNameSet.clear();
        purchaseSummaryItemMap.clear();
        selectedProdMap.clear();
        selectedProdList.clear();
    }
    
}