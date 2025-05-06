// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC223Recipient {
    function tokenFallback(address from, uint256 value, bytes calldata data) external;
}

contract IntermediateERC223Token {
    string public name = "IntermediateToken";
    string public symbol = "ITK";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;
    bool public paused;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Paused();
    event Unpaused();
    event Burned(address indexed from, uint256 amount);
    event Minted(address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier notPaused() {
        require(!paused, "Paused");
        _;
    }

    constructor(uint256 _supply) {
        owner = msg.sender;
        totalSupply = _supply;
        balanceOf[msg.sender] = _supply;
    }

    function isContract(address _addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(_addr) }
        return size > 0;
    }

    function transfer(address _to, uint256 _value, bytes calldata _data) public notPaused returns (bool) {
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

    function approve(address _spender, uint256 _value) public notPaused returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public notPaused returns (bool) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Not approved");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;

        bytes memory empty = "";
        if (isContract(_to)) {
            IERC223Recipient(_to).tokenFallback(_from, _value, empty);
        }

        emit Transfer(_from, _to, _value, empty);
        return true;
    }

    function pause() public onlyOwner {
        paused = true;
        emit Paused();
    }

    function unpause() public onlyOwner {
        paused = false;
        emit Unpaused();
    }

    function burn(uint256 _amount) public notPaused {
        require(balanceOf[msg.sender] >= _amount, "Insufficient balance");
        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
        emit Burned(msg.sender, _amount);
    }

    function mint(address _to, uint256 _amount) public onlyOwner {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
        emit Minted(_to, _amount);
    }
}
