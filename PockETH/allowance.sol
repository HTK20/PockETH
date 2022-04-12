//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import"https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract Allowance is Ownable{
    
    using SafeMath for uint;
    event AllowanceChanged(address indexed _forWho, address indexed _fromWhom,uint _oldAmount, uint _newAmount);

    mapping (address => uint) public allowance;

    function isOwner() public view returns (bool){ //CHECKS IF CURRENT USER IS OWNER OR NOT
        return _msgSender()== owner();
    }
    function addAllowance(address _who, uint _amount) public onlyOwner{
        emit AllowanceChanged(_who,msg .sender,allowance[_who],_amount);
        allowance[_who] = _amount;     
    }

    modifier ownerOrAllowed(uint _amount){ //Security check where it is checked if access is invoked by owner and if requested allownance is greater than available balance
        require(isOwner() || allowance[msg.sender]>= _amount, "You're not allowed");
        _;
    }
    function reducedAllowance(address _who,uint _amount) internal {
        emit AllowanceChanged(_who,msg.sender,allowance[_who],allowance[_who].sub(_amount));
        allowance[_who] =allowance[_who].sub(_amount); 
    }

}