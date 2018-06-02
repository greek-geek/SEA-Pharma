pragma solidity ^0.4.24;

contract TransModel {
    uint public transactionId;

    struct Transaction {
        // uint id;
        uint drugId;
        string drugName;
        uint buyerId;
        string buyerName;
        uint sellerId;
        string sellerName;
        uint userType;
        uint quantity;
        // string location_;
        address transactionAddedBy;
    }
    
    mapping (uint => Transaction) transactions;
    uint[] public transactionsArr;
}

contract Owned is TransModel {
    address owner;
    
    
    function Owned() public {
        owner = msg.sender;
    }
    
   modifier onlyOwner {
       require(msg.sender == owner);
       _;
   }
   
   modifier canAddTransactions (uint _userType) {
       require(_userType < 4);
       _;
   }
   
   modifier onlyManufacturererCanAddNewDrugId(uint _userType, uint _drugId) {
       
       bool condition = false;
       
       bool drugIdExists = false;
       for(uint i=0; i<transactionsArr.length; i++) {
           if(transactions[transactionsArr[i]].drugId == _drugId) {
               drugIdExists = true;
           }
       }
       
       if(_userType == 1){
           if(!drugIdExists){
               condition = true;
           }
       }
       else{
           if(drugIdExists){
               condition = true;
           }
       }
       
       require(condition);
       _;
       
   }
   
   modifier checkIntegrity(uint _userType, uint _drugId, uint _sellerId, uint _quantity) {
       bool condition = false;
       if(!(_userType == 1)){
           
           uint qty_final = 0;
           for(uint i=0; i<transactionsArr.length; i++){
               uint _dID = transactions[transactionsArr[i]].drugId;
               
               if(_drugId == _dID)
                {
                    uint _qty = transactions[transactionsArr[i]].quantity;
                    uint sID = transactions[transactionsArr[i]].sellerId;
                    uint bID = transactions[transactionsArr[i]].buyerId;
                    if(sID == _sellerId){//you act as seller earlier so minus qty
                        qty_final-= _qty;
                    }
                    
                    if(bID == _sellerId){//you act as buyer earlier so add qty
                        qty_final+= _qty;
                    }
                }
           }
           
           if(qty_final >= _quantity){
            condition=true;
           }
       }
       else
        condition=true;
       require(condition);
       _;
   }
   

}

contract SeaPharma is Owned {
    
    uint public blockNumber = block.number;
    bytes32 public blockHashNow = block.blockhash(blockNumber);
    bytes32 public blockHashPrevious = block.blockhash(blockNumber - 1);

    // struct Transaction {
    //     uint id;
    //     uint drugId;
    //     string drugName;
    //     uint buyerId;
    //     string buyerName;
    //     uint sellerId;
    //     string sellerName;
    //     string userType;
    //     uint quantity;
    //     string location_;
    //     address transactionAddedBy;
    // }
    
    // mapping (uint => Transaction) transactions;
    // uint[] public transactionsArr;

    event transactionInfo(
        uint id,
        uint drugId,
        string drugName,
        uint buyerId,
        string buyerName,
        uint sellerId,
        string sellerName,
        uint userType,
        uint quantity,
        // string location_,
        address transactionAddedBy
    );
    
    function getTransactionId() public returns (uint) {
        return transactionId++;
    }

    
    function setDrugTransaction(
        uint _drugId, 
        string _drugName, 
        uint _buyerId, 
        string _buyerName, 
        uint _sellerId, 
        string _sellerName, 
        uint _userType, 
        uint _quantity) onlyOwner onlyManufacturererCanAddNewDrugId(_userType, _drugId) canAddTransactions(_userType) public returns(uint){
        var _id = getTransactionId();
        // var transaction = transactions[_id];
        
        // transaction.id = _id;
        transactions[_id].drugId = _drugId;
        transactions[_id].drugName = _drugName;   
        transactions[_id].buyerId = _buyerId;
        transactions[_id].buyerName = _buyerName;
        transactions[_id].sellerId = _sellerId;
        transactions[_id].sellerName = _sellerName;
        transactions[_id].userType = _userType;
        transactions[_id].quantity = _quantity;
        // transactions[_id].location_ = _location;
        transactions[_id].transactionAddedBy = msg.sender;
        
        transactionsArr.push(_id) -1;

        // transactionInfo(_id , _drugId, _drugName, _buyerId, _buyerName, _sellerId, _sellerName, _userType, _quantity, msg.sender);
    
        return _id;        
    }
    
    function getAllTransactions() view public returns(uint[]) {
        
        return transactionsArr;
    }
    
    function getTransactionDetails(uint _id) view public returns (uint, string, uint, uint, address) {
        return (transactions[_id].drugId, transactions[_id].drugName, transactions[_id].quantity, transactions[_id].userType, transactions[_id].transactionAddedBy);
    }
    
    function getBuyerSellerDetails(uint _id) view public returns (uint, string, uint, string, uint, bytes32, bytes32) {
        
        return (transactions[_id].buyerId, transactions[_id].buyerName, transactions[_id].sellerId, transactions[_id].sellerName, blockNumber, blockHashNow, blockHashPrevious);
    }
    
    function countTransactions() view public returns (uint) {
        return transactionsArr.length;
    }
    
}
    
    