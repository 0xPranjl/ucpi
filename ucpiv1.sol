// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ucpinaming{
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
    mapping(string=>address) public idowner;
    //mapping of wallet owner address
     mapping(string=>address) public  walletowner;
     //mapping of wallet existance
    mapping(address=>uint) public walletownercount;
    //number of ucpiid made by an address by default is 2 for more need to pay 151 harmony per id
    mapping(address=>bool) public ispremium;
    //account that has more than 2 ucpiid 
    mapping(string=>uint) public idprice;
    address public ucpimultisign=0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    function createid(string memory _id,string memory _brand,string memory _address,string memory _walletname,bytes memory sign) external {
        _id=validate(_id);
          bytes32 wlcmhash=0x894717e02bc1017f7347665a198b3cb74671478407a02a65b750d7e88f8f8570;
          bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(sign);
        bytes32 prefixedHashMessage = keccak256(abi.encodePacked(prefix,wlcmhash));
         
        address wa=ecrecover(prefixedHashMessage, v, r, s);
        
        require(keccak256(abi.encodePacked("ucpi"))==keccak256(abi.encodePacked(_brand)),"no custom brands allowed");
        _walletname=validate(_walletname);
        
         if(ispremium[wa]==false){
           require(walletownercount[wa]<2,"free tier complete please purchase premium ");
         }  
         else{ 
         }
          
         require(idexist[string(abi.encodePacked(_id,"@",_brand))]==false,"id not present");
      //require(&&idexist[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=false,"wall")
        mainid[string(abi.encodePacked(_id,"@",_brand))]=_address;
        walletsubwallet[string(abi.encodePacked(_id,"@",_brand))]=string(abi.encodePacked(_id,"@",_brand,"$",_walletname));
        numofwallet[string(abi.encodePacked(_id,"@",_brand))]+=1;
        wallet[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=_address;
        idexist[string(abi.encodePacked(_id,"@",_brand))]=true;
        primarywallet[string(abi.encodePacked(_id,"@",_brand))]=_walletname;
        idexist[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=true;
        idowner[string(abi.encodePacked(_id,"@",_brand))]=wa;
        walletowner[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=wa;
        walletownercount[wa]+=1;
        ispremium[wa]=false;
         
    }
    function updateaddress(string memory _id,string memory _brand,string memory _walletname,string memory _add) external {
        //bytes memory b=bytes(_address);
        _id=validate(_id);
        _brand=validate(_brand);
         require(keccak256(abi.encodePacked("ucpi"))==keccak256(abi.encodePacked(_brand)),"no custom brands allowed");
        _walletname=validate(_walletname);
   require(walletowner[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]==msg.sender);
        wallet[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=_add;
    }
    function addwallet(string memory _id,string memory _brand,string memory _walletname,string memory _add,address _ethadd) external{
     _id=validate(_id);
        _brand=validate(_brand);
        _walletname=validate(_walletname);
         require(keccak256(abi.encodePacked("ucpi"))==keccak256(abi.encodePacked(_brand)),"no custom brands allowed");
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
          require(keccak256(abi.encodePacked("ucpi"))==keccak256(abi.encodePacked(_brand)),"no custom brands allowed");
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
 function recoverSigner(bytes memory _signature)
        public
        pure
        returns (address)
    {
         // bytes memory prefix = "\x19Ethereum Signed Message:\n32";
  //       (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
  // bytes32 prefixedHashMessage = keccak256(abi.encodePacked(prefix, _ethSignedMessageHash));
           bytes32 wlcmhash=0x894717e02bc1017f7347665a198b3cb74671478407a02a65b750d7e88f8f8570;
          bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
        bytes32 prefixedHashMessage = keccak256(abi.encodePacked(prefix,wlcmhash));
         
        return ecrecover(prefixedHashMessage, v, r, s);
    }

    function VerifyMessage(bytes32 _hashedMessage, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (address) {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 prefixedHashMessage = keccak256(abi.encodePacked(prefix, _hashedMessage));
        address signer = ecrecover(prefixedHashMessage, _v, _r, _s);
        return signer;
    }
   function splitSignature(bytes memory sig)
        public
        pure
        returns ( bytes32 r,bytes32 s,uint8 v)   
    {
        require(sig.length == 65, "invalid signature length");
            
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }

//     function get(string memory key) 
//     public 
//     view 
//     returns (bytes32) {
//         return bytes32(abi.encodePacked(key));
// }
function upgradeplan() external payable{
  require(msg.value== 2000000000000000000,"please send 2 ");
  payable(ucpimultisign).transfer(150000000);
  ispremium[msg.sender]=true;
}
function bal() public view returns(uint){
  return address(this).balance;
}


}
