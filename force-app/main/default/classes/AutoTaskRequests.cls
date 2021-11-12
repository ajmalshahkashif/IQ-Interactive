public class AutoTaskRequests{
    
    public class RequestFields{
        
        public String op {get; set;}
        public String field {get; set;}
        public String value {get; set;}  
        
        public RequestFields(String op, String field, String value){
            
            this.op = op;
            this.field = field;
            this.value = value;
            
        }
        
               
        
    }
    
    public class RequestFieldsWrapper{
        
        public List<String> IncludeFields {get; set;}
        public List<RequestFields> filter {get; set;}
        
        public RequestFieldsWrapper(List<String> IncludeFields, List<RequestFields> filter){
            
            this.IncludeFields = IncludeFields;
            this.filter = filter;
        }
    }
    
    public class RequestQuoteLocation{
        
        public String address1 {get; set;} 
        public String city {get; set;}
        public String state {get; set;}
        public String postalCode {get; set;}
        
        public RequestQuoteLocation(String address1, String city, 
                                    String state, String postalCode){
                                        
                                        this.address1 = address1;
                                        this.city = city;
                                        this.state = state;
                                        this.postalCode = postalCode;
                                    }
    }
    
    public class UDFields{
        public String name {get; set;}
        public String value {get; set;}
        public UDFields(String name, String value){
            this.name = name;
            this.value = value;
        }
    }
    public class RequestCompany{        
        public String countryId {get; set;}
        public String address1 {get; set;} 
        public String city {get; set;}
        public String state {get; set;}
        public String postalCode {get; set;}
        public String companyName {get; set;}
        public String companyType {get; set;}
        public String isActive {get; set;}
        public String Phone {get; set;}
        public String ownerResourceID {get; set;}
        public String primaryProduct {get; set;}
        public List<UDFields> userDefinedFields {get; set;}
        
        public RequestCompany(String countryId, String address1, String city, 
                              String state, String postalCode, String companyName, String companyType,
                              Boolean IsActive, String phone, String ownerResourceID, List<UDFields> udf){
                                  
                                  this.countryId = countryId;
                                  this.address1 = address1;
                                  this.city = city;
                                  this.state = state;
                                  this.postalCode = postalCode;
                                  this.companyName = companyName;
                                  this.companyType = companyType;
                                  this.IsActive = String.ValueOf(IsActive);
                                  this.Phone = Phone;
                                  this.ownerResourceID = ownerResourceID;
                                  this.userDefinedFields = udf;
                              }
    }
    
    public class RequestContact{
        
        public Integer isActive {get; set;}
        public String lastName {get; set;}
        public String firstName {get; set;}
        public String companyID {get; set;}
        
        public String emailAddress {get; set;}
        public String mobilePhone {get; set;}
        public String phone {get; set;}
        
        public RequestContact(Integer isActive, String lastName, String firstName, String companyID, 
                              String emailAddress, String mobilePhone, String phone){
            
            this.isActive = isActive;
            this.lastName = lastName;
            this.firstName = firstName;
            this.companyID = companyID;
            this.emailAddress = emailAddress;
            this.mobilePhone = mobilePhone;
            this.phone = phone;
            
        }
    }
    
    public class RequestOpportunity{
        
        public String amount {get; set;}
        public String companyID {get; set;}
        public String contactId {get; set;}
        public String cost {get; set;}
        public String ownerResourceID {get; set;}
        public String probability {get; set;}
        public date projectedCloseDate {get; set;}
        public date createDate {get; set;}
        public String creatorResourceID {get; set;}
        public Integer opportunityCategoryID {get; set;}
        public String stage {get; set;}
        public date startDate {get; set;}
        public String status {get; set;}
        public String title {get; set;}
        public String useQuoteTotals {get; set;}
        
        public RequestOpportunity(Decimal amount, String companyID, String contactId, Decimal cost,String ownerResourceID, 
                                  String probability, Date projectedCloseDate,Date createDate, String creatorResourceID,
                                  Integer opportunityCategoryID,String stage,Date startDate, String status,
                                  String title, String useQuoteTotals){
                                      
                                      this.amount = String.ValueOf(amount);
                                      this.companyID = companyID;
                                      this.contactId = contactId;
                                      this.cost = String.ValueOf(cost);
                                      this.ownerResourceID = ownerResourceID;
                                      this.probability = probability;
                                      this.projectedCloseDate = projectedCloseDate;
                                      this.createDate = createDate;
                                      this.creatorResourceID = creatorResourceID;
                                      this.opportunityCategoryID = opportunityCategoryID;
                                      this.stage = stage;
                                      this.startDate = startDate;
                                      this.status = status;
                                      this.title = title;
                                      this.useQuoteTotals = useQuoteTotals;
                                  }
    }
    
    public class RequestQuote{
        
        public String billToLocationID {get; set;}
        public String opportunityID {get; set;}
        public String contactID {get; set;}
        public String effectiveDate {get; set;}
        public String expirationDate {get; set;}
        public String Name {get; set;}
        public String shipToLocationID {get; set;}
        public String soldToLocationID {get; set;}
        
        public RequestQuote(String billToLocationID, String opportunityID, String contactID, String effectiveDate, 
                            Date expirationDate,
                            String name, String shipToLocationID,
                            String soldToLocationID){
                                
                                this.billToLocationID = billToLocationID;
                                this.opportunityID = opportunityID;
                                this.contactID = contactID;
                                this.effectiveDate = effectiveDate;
                                this.expirationDate = String.ValueOf(expirationDate);
                                this.Name = name;
                                this.shipToLocationID = shipToLocationID;
                                this.soldToLocationID = soldToLocationID;
                            }
    }
    
    public class RequestQuoteItems{
        
        public String quoteid {get; set;}
        public String isOptional {get; set;}
        public String unitDiscount {get; set;}
        public String quantity {get; set;}
        public String unitPrice {get; set;}
        public String quoteItemType {get; set;}
        public String periodType {get; set;}
        public String productID {get; set;}
        public String name {get; set;}
        public String lineDiscount {get; set;}
        public String percentageDiscount {get; set;}
        
        public RequestQuoteItems(String quoteid, Boolean isOptional, String unitDiscount, 
                                 Decimal quantity, Decimal unitPrice, String quoteItemType, 
                                 Integer periodType, String productID,
                                 String name, String lineDiscount,
                                 String percentageDiscount){
                                     
                                     this.quoteid = quoteid;
                                     this.isOptional = String.ValueOf(isOptional);
                                     this.unitDiscount = unitDiscount;
                                     this.quantity = String.ValueOf(quantity);
                                     this.unitPrice = String.ValueOf(unitPrice);
                                     this.quoteItemType = quoteItemType;
                                     this.periodType = String.ValueOf(periodType);
                                     this.productID = productID;
                                     this.name = name;
                                     this.lineDiscount = lineDiscount;
                                     this.percentageDiscount = percentageDiscount;
                                 }
    }
    
}