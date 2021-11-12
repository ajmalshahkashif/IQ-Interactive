public class AutoTaskResponses {
    
    public class ResponseFields{
        
        public List<ResponseItems> Items {get; set;}
        public ResponsePageDetails pageDetails {get; set;}
        
        public ResponseFields(List<ResponseItems> Items, 
                              ResponsePageDetails pageDetails){
                                  
                                  this.Items = Items;
                                  this.pageDetails = pageDetails;
                              }
    }
    
    public class ResponseItems{
        
        public String id {get; set;}
        public String address1 {get; set;}
        public String city {get; set;}
        public String companyName {get; set;}
        public String postalCode {get; set;}
        public String state {get; set;}
        public List<String> userDefinedFields {get; set;}
        
        public ResponseItems(String id, String address1, String city, 
                             String companyName, String postalCode,
                             String state, List<String> userDefinedFields){
                                 
                                 this.id = id;
                                 this.address1 = address1;
                                 this.city = city;
                                 this.companyName = companyName;
                                 this.postalCode = postalCode;
                                 this.state = state;
                                 this.userDefinedFields = userDefinedFields;
                             }
    }

    public class ResponsePageDetails{
        
        public String count {get; set;}
        public String requestCount {get; set;}
        public String prevPageUrl {get; set;}
        public String nextPageUrl {get; set;}
        
        public ResponsePageDetails(String count, String requestCount, 
                                   String prevPageUrl, String nextPageUrl){
                                       
                                       this.count = count;
                                       this.requestCount = requestCount;
                                       this.prevPageUrl = prevPageUrl;
                                       this.nextPageUrl = nextPageUrl;
                                   }
    }
    
    public class ResponseItemId{
        
        public string itemId {get; set;}
        
        public ResponseItemId(string itemId){
            this.itemId = itemId;
        }
    }
    
    public class ResponseContact{
        
        public string itemId {get; set;}
        public string id {get; set;}
       
        public ResponseContact(string contId, string idd){
            this.itemId = contId;
            this.id = idd;
        }
    }
    
}