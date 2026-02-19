// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SaveEthAndERCtoken {
    // string 

     event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval (address indexed _owner, address indexed _spender, uint256 _value);
    event DepositSuccessful(address indexed _owner, uint256 _value);
       event withdrawalSuccessful(address indexed _owner, uint256 _value);

    mapping (address => uint256) _balance;
        mapping (address =>mapping (address => uint)) _allowances;

    

    function withdrawToken(address _receiver, uint256 _value)external payable returns (bool){
        require(_balance[msg.sender] >= _value, "Insufficient balance");
        require(_receiver !=address(0));
        _balance[msg.sender] =_balance[msg.sender]- _value;
        _balance[_receiver] =  _balance[_receiver] + _value;
        
        emit withdrawalSuccessful(_receiver, _value);
        return true;
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
