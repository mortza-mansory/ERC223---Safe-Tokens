// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC223Recipient {
    function tokenFallback(address from, uint256 value, bytes calldata data) external;
}

contract BasicERC223Token {
    string public name = "BasicToken";
    string public symbol = "BTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value, bytes data);

    constructor(uint256 _supply) {
        totalSupply = _supply;
        balanceOf[msg.sender] = _supply;
    }

    function isContract(address _addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(_addr) }
        return size > 0;
    }

    function transfer(address _to, uint256 _value, bytes calldata _data) public returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        if (isContract(_to)) {
            IERC223Recipient(_to).tokenFallback(msg.sender, _value, _data);
        }

        emit Transfer(msg.sender, _to, _value, _data);
        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        bytes memory empty = "";
        return transfer(_to, _value, empty);
    }
}
