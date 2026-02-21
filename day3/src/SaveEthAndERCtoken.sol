// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {IERC20} from "./IERC20.sol";


contract SaveEthAndERCtoken {
    // string 
 address tokenAddress;

    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
    }
     event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval (address indexed _owner, address indexed _spender, uint256 _value);
    event DepositSuccessful(address indexed _owner, uint256 _value);
    event WithdrawalSuccessful(address indexed _owner, uint256 _value);

    mapping (address => uint256) _balance;
        mapping (address =>mapping (address => uint)) _allowances;
    mapping(address => uint256) erc20Savingsbalance;

    
function depositERC20(uint256 _amount) external {
        require(_amount > 0, "Can't send zero value");

        require(IERC20(tokenAddress).balanceOf(msg.sender) >= _amount, "Insufficient funds");

        erc20Savingsbalance[msg.sender] = erc20Savingsbalance[msg.sender] + _amount;

        require(IERC20(tokenAddress).transferFrom(msg.sender, address(this), _amount), "transfer failed");

        emit DepositSuccessful(msg.sender, _amount);
    }


    function withdraw(uint256 _amount) external {
        require(msg.sender != address(0), "Address zero detected");

        uint256 userSavings_ = _balance[msg.sender];

        require(userSavings_ > 0, "Insufficient funds");

        _balance[msg.sender] = userSavings_ - _amount;

        // (bool result,) = msg.sender.call{value: msg.value}("");
        (bool result, bytes memory data) = payable(msg.sender).call{value: _amount}("");

        require(result, "transfer failed");

    }

    function getUserSavings() external view returns (uint256) {
        return _balance[msg.sender];
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }


 function balanceOf(address _owner ) public view returns (uint256){
        require(_owner != address(0), "Zero address detected");
        return _balance[_owner];
    }

function deposit(address _from, uint256 _value) external payable {
            require(msg.sender != address(0), "Zero address detected");
        require(msg.value > 0, "Can't deposit zero value");
        _balance[msg.sender] = _balance[msg.sender] + _value;
         _balance[_from] = _balance[_from] - _value;

        emit DepositSuccessful(_from, _value);
    }
}
