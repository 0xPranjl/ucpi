// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ucpi{
    //main ucpi mapping
    mapping(string=>string) public mainid;
    //check if wallet exist
    mapping(string=>bool) public idexist;
    //primary wallet of id
    mapping(string=>string) public primarywallet;
    //wallet name address mapping 
    mapping(string=>string) public wallet;
    //sub wallets linked with id
    mapping(string=>string) public walletsubwallet;
    //number of wallet linked with id count
    mapping(string=>uint) public numofwallet;
    //mapping of id owner
    mapping(string=>address) idowner;
    //mapping of wallet owner address
     mapping(string=>address) walletowner;
     //mapping of wallet existance
  
    function createid(string memory _id,string memory _brand,string memory _address,string memory _walletname) external {
        _id=validate(_id);
        _brand=validate(_brand);
        _walletname=validate(_walletname);
        require(idexist[string(abi.encodePacked(_id,"@",_brand))]==false,"id not present");
      //  require(&&idexist[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=false,"wall")
        mainid[string(abi.encodePacked(_id,"@",_brand))]=_address;
        walletsubwallet[string(abi.encodePacked(_id,"@",_brand))]=string(abi.encodePacked(_id,"@",_brand,"$",_walletname));
        numofwallet[string(abi.encodePacked(_id,"@",_brand))]+=1;
        wallet[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=_address;
        idexist[string(abi.encodePacked(_id,"@",_brand))]=true;
        primarywallet[string(abi.encodePacked(_id,"@",_brand))]=_walletname;
        idexist[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=true;
        idowner[string(abi.encodePacked(_id,"@",_brand))]=msg.sender;
        walletowner[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]==msg.sender;
    }
    function updateaddress(string memory _id,string memory _brand,string memory _walletname,string memory _add) external {
        //bytes memory b=bytes(_address);
        _id=validate(_id);
        _brand=validate(_brand);
        _walletname=validate(_walletname);
   require(walletowner[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]==msg.sender);
        wallet[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=_add;
    }
    function addwallet(string memory _id,string memory _brand,string memory _walletname,string memory _add,address _ethadd) external{
     _id=validate(_id);
        _brand=validate(_brand);
        _walletname=validate(_walletname);
     require(idowner[string(abi.encodePacked(_id,"@",_brand))]==msg.sender);
     require( idexist[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]==false,"wallet name exists");
     wallet[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=_add;
     walletowner[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=_ethadd;
       walletsubwallet[string(abi.encodePacked(_id,"@",_brand))]=string(abi.encodePacked(walletsubwallet[string(abi.encodePacked(_id,"@",_brand))],",",_id,"@",_brand,"$",_walletname));
     numofwallet[string(abi.encodePacked(_id,"@",_brand))]+=1;
    }
    function changeprimary(string memory _id,string memory _brand,string memory _walletname,address _ethadd) external{
         _id=validate(_id);
        _brand=validate(_brand);
        _walletname=validate(_walletname);
         require(idowner[string(abi.encodePacked(_id,"@",_brand))]==msg.sender);
         require( idexist[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=true,"wallet name exists");
          primarywallet[string(abi.encodePacked(_id,"@",_brand))]=_walletname;
          idowner[string(abi.encodePacked(_id,"@",_brand))]=_ethadd;
    }
    function validate(string memory s) public pure returns(string memory){
     bytes memory bStr = bytes(s);
        bytes memory bLower = new bytes(bStr.length);
        for (uint i = 0; i < bStr.length; i++) {
            // Uppercase character...
            if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
                // So we add 32 to make it lowercase
                bLower[i] = bytes1(uint8(bStr[i]) + 32);
            }
            else if((uint8(bStr[i]) >= 33) && (uint8(bStr[i]) <= 47)){
              revert("special character not allowed");
            } 
            else if((uint8(bStr[i]) >= 58) && (uint8(bStr[i]) <= 64)){
              revert("special character not allowed");
            } 
             else if((uint8(bStr[i]) >= 91) && (uint8(bStr[i]) <= 96)){
              revert("special character not allowed");
            } 
             else if((uint8(bStr[i]) >= 123) && (uint8(bStr[i]) <= 127)){
              revert("special character not allowed");
            } 
            
            else {
                bLower[i] = bStr[i];
            }
        }
        return string(bLower);
    }
}
