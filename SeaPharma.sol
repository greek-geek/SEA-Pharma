pragma solidity ^0.4.24;

contract Owned {
    address owner;
    
    
    function Owned() public {
        owner = msg.sender;
    }
    
   modifier onlyOwner {
       require(msg.sender == owner);
       _;
   }
}

contract SeaPharma is Owned {
    
    uint public transactionId;
    
    struct Transaction {
        uint id;
        uint drugId;
        string drugName;
        uint buyerId;
        string buyerName;
        uint sellerId;
        string sellerName;
        uint quantity;
        string location_;
        address transactionAddedBy;
    }
    
    struct Transaction_subset {
        uint drugId;
        string drugName;
        uint buyerId;
        string buyerName;
        uint sellerId;
        string sellerName;
        
    }
    
    mapping (uint => Transaction) transactions;
    uint[] public transactionsArr;

    event transactionInfo(
        uint id,
        uint drugId,
        string drugName,
        uint buyerId,
        string buyerName,
        uint sellerId,
        string sellerName,
        uint quantity,
        string location_,
        address transactionAddedBy
    );
    
    function getTransactionId() public returns (uint) {
        return transactionId++;
    }
    
    function setDrugTransaction(uint _drugId, string _drugName, uint _buyerId, string _buyerName, uint _sellerId, string _sellerName, uint _quantity, string _location, address _address) onlyOwner public{
        var _id = getTransactionId();
        var transaction = transactions[_id];
        
        transaction.id = _id;
        transaction.drugId = _drugId;
        transaction.drugName = _drugName;   
        transaction.buyerId = _buyerId;
        transaction.buyerName = _buyerName;
        transaction.sellerId = _sellerId;
        transaction.sellerName = _sellerName;
        transaction.quantity = _quantity;
        transaction.location_ = _location;
        transaction.transactionAddedBy = _address;
        
        transactionsArr.push(_id) -1;
        

        transactionInfo(_id, _drugId, _drugName, _buyerId, _buyerName, _sellerId, _sellerName, _quantity, _location, _address);
    }
    
    function getAllTransactions() view public returns(uint[]) {
        return transactionsArr;
    }
    
    function getTransactionDetails(uint _id) view public returns (uint, string, uint, string, address) {
        return (transactions[_id].drugId, transactions[_id].drugName, transactions[_id].quantity, transactions[_id].location_, transactions[_id].transactionAddedBy);
    }
    
    function getBuyerSellerDetails(uint _id) view public returns (uint, string, uint, string, uint, string) {
        return (transactions[_id].drugId, transactions[_id].drugName, transactions[_id].buyerId, transactions[_id].buyerName, transactions[_id].sellerId, transactions[_id].sellerName);
    }
    
    function countTransactions() view public returns (uint) {
        return transactionsArr.length;
    }
    
}
    
    