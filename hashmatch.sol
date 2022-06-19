// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract hash{
uint id;
address public owner;
mapping(bytes32=>address) data;
mapping(bytes32=>address) keyowner;
mapping(uint=>bytes32) alldata;

constructor(){
    owner=msg.sender;
    
}
modifier onlyOwner (){
require(msg.sender==owner,"You are not owner!");
_;
}
function putdata(string memory _k) external{
  if(keyowner[sha256(abi.encodePacked(_k))]==0x0000000000000000000000000000000000000000){
   data[sha256(abi.encodePacked(_k))]=msg.sender;    
   keyowner[sha256(abi.encodePacked(_k))]=msg.sender;
   alldata[id]=sha256(abi.encodePacked(_k));
   id++;
  }
  else{
    require(1==2,"All things are immutable");
    // data[_k]=_v; 
       
  }
}

function getdata(string memory _k) view external returns(address){
    
  return data[sha256(abi.encodePacked(_k))];    

}
function getkeyat(uint _cv) view external returns(bytes32){
  return alldata[_cv];
}

function getnokey() view external returns(uint){
return id;
}

function kill() external{
  selfdestruct(payable(owner));
}

}
