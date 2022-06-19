// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract ucpi_v1{
uint id;
address public owner;
mapping(string=>string) data;
mapping(string=>address) keyowner;
mapping(uint=>string) alldata;

constructor(){
    owner=msg.sender;
    
}
modifier onlyOwner (){
require(msg.sender==owner,"You are not owner!");
_;
}
function putdata(string memory _k,string memory _v) external{
  if(keyowner[_k]==0x0000000000000000000000000000000000000000){
   data[_k]=_v;    
   keyowner[_k]=msg.sender;
   alldata[id]=_k;
   id++;
  }
  else{
    require(keyowner[_k]==msg.sender,"only owner of data can edit it!");
    data[_k]=_v; 
       
  }
}

function getdata(string memory _k) view external returns(string memory){
    
  return data[_k];    

}

function getnokey() view external returns(uint){
return id;
}

function getkeyat(uint _i) view external returns(string memory){
return alldata[_i];
}


function kill() onlyOwner external {
  selfdestruct(payable(owner));
}
}
