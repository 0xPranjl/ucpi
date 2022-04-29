// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/utils/Strings.sol";
interface ucpi_v1{
    function getdata(string memory _k) view external returns(string memory);
}
contract missed_call{
uint num_of_data;
mapping(string=>bool) id;
mapping(string=>uint) idmatic;
event Claims(
  string missid,
  address claimadd
);
struct claimdata{
  address claimaddress;
  bytes32 claimhash;
  bool claimstatus; 
}
mapping(string=>claimdata) public cd;
function check_missedcall_id(string memory _id) view public returns (string memory){
  bytes memory x=bytes(_id);
  if(x.length==0){
   return "why blank?"; 
  }
  else{
string memory s= ucpi_v1(0x9fbFDDdd089692fDf00b5EdA5EB599fA2309b2b8).getdata(_id);
return s;
  }
}
function add_missedcall_id(string memory _id) external returns(string memory po){
require(id[_id]==false,"not available!");
string memory x=check_missedcall_id(_id);
bytes memory tempEmptyStringTest = bytes(x); 
if (tempEmptyStringTest.length == 0 ) {
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
} else {
    return "not available!";
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
function sethash(string memory _id,string memory hashdata,address claimadd) external{
  require(msg.sender==0x814B740147c9c8A312a83115ae26c07f119Ef035,"you cannot set hash");
  cd[_id]=claimdata(claimadd,sha256(abi.encodePacked(hashdata)),false);
}
function finalclaim(string memory _id,string memory dataforhash) external{
 require(cd[_id].claimhash==sha256(abi.encodePacked(dataforhash)),"wrong password!");
 payable(msg.sender).transfer(idmatic[_id]);
 cd[_id].claimstatus=true;
 idmatic[_id]=0;
}
function ca(string memory Pid) external view returns (address){
  return cd[Pid].claimaddress;
}
}
