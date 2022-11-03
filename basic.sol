// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStore {
  function set(uint _value) public {
    value = _value;
  }

  function get() public view returns (uint) {
    return value;
  }

  uint value;
}

//deployed on harmony devnet
//smartcontract address-0xb058d848116c474996679C9DF0273B80b5f951E3
