// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/utils/Strings.sol";
contract missed_call{
  fallback() external payable {}
 receive() external payable{}
uint num_of_data;
mapping(string=>bool) id;
mapping(string=>uint) idmatic;
mapping(string=>string) cspid;
mapping(string=>string) wallets;
mapping(string=>bool) wallet_exist;
event Claims(
  string missid,
  address claimadd
);
struct claimdata{
  string claimaddress;
  bytes32 claimowner_hash;
  bytes32 claimhash;
  bool claimstatus; 
}
mapping(string=>claimdata) public cd;

function add_missedcall_id(string memory _id) external{
require(id[_id]==false,"not available!");
 uint allowedChars =0;
        bytes memory byteString = bytes(_id);
        bytes memory allowed = bytes("+0123456789");  
        for(uint i=0; i < byteString.length ; i++){
           for(uint j=0; j<allowed.length; j++){
              if(byteString[i]==allowed[j] )
              allowedChars++;         
           }
        }
        if(allowedChars<byteString.length){
          revert();
        }
      
        else{
          id[_id]=true;
        }
}
function sendmissid(string memory _id) external payable{
   idmatic[_id]=idmatic[_id]+msg.value;
}
function getid(string memory _id) view external returns(bool) {
  return id[_id];
}
function getmissbal(string memory _id) view external returns(uint){
 return idmatic[_id];
}
function claimid(string memory _id) external{
require(id[_id]==true,"id not found!");
emit Claims(_id,msg.sender);
}
function sethash(string memory _id,string memory hashdata) external{
 require(msg.sender==0x626cd41ccA5944Eae4244b7b8f3b9f6249AEc039,"you cannot set hash");
  cd[_id]=claimdata("0x0000000000000000000000000000000000000000",sha256(abi.encodePacked("0x0000000000000000000000000000000000000000")),sha256(abi.encodePacked(hashdata)),false);
}
function finalclaim(string memory _id,string memory dataforhash,string memory allkeys) external{
 require(cd[_id].claimhash!=0x0000000000000000000000000000000000000000000000000000000000000000,"Hash not set");
 require(cd[_id].claimhash==sha256(abi.encodePacked(dataforhash)),"wrong password!");
 payable(msg.sender).transfer(idmatic[_id]);
 cd[_id].claimstatus=true;
 cd[_id].claimaddress=allkeys;
 cd[_id].claimowner_hash=sha256(abi.encodePacked(msg.sender));
 idmatic[_id]=0;
}
function ca(string memory Pid) external view returns (string memory){
  return cd[Pid].claimaddress;
}
function tbal() external view returns (uint){
  return address(this).balance;
}
function updateaddress(string memory __id,string memory badrress,string memory wallet_name) external{
  require(cd[__id].claimowner_hash==sha256(abi.encodePacked(msg.sender)),"you are not authorised!");
   cd[__id].claimaddress=badrress;
    wallets[wallet_name]=badrress;
}
function addwallet(string memory __id,string memory wallet_name,string memory badrress) external{
  require(cd[__id].claimowner_hash==sha256(abi.encodePacked(msg.sender)),"you are not authorised!");
  require(wallet_exist[wallet_name]==false,"wallet name already exist");
   cd[__id].claimaddress=badrress;
   wallets[wallet_name]=badrress;
   wallet_exist[wallet_name]=true;
}
function changePrimarywallet(string memory __id,string memory badrress) external{
  require(cd[__id].claimowner_hash==sha256(abi.encodePacked(msg.sender)),"you are not authorised!");
   cd[__id].claimowner_hash=sha256(abi.encodePacked(msg.sender));
    cd[__id].claimaddress=badrress;
  //cd[__id].claimaddress;
}
function magicbalance(string memory _id) external view returns(uint){
  return idmatic[_id];
}
function claimstatus(string memory _id) external view returns(bool){
  return cd[_id].claimstatus;
}
function idownerhash(string memory _id) external view returns(bytes32){
  return cd[_id].claimowner_hash;
} 
function getwallet(string memory _id) external view returns(string memory){
return wallets[_id];
}
}
