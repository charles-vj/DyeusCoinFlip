// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

contract Coinflip {

    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    struct User{
        uint balance;
        uint bet;
        uint amount;
    }

    // bet can have 4 values in total
    // 0 = never participated in any bet
    // 1 = heads
    // 2 = tails
    // 3 = user has participated in an earlier bet

    mapping(address => uint) addressToBalance; //will not be required but was mentioned in the assignment
    mapping(address => User) addressToUser;

    address[] bettors;

    function bet(uint _amount,uint _choice) external {
        
        require(_choice==1 || _choice==2,"Invalid bet");
        if(addressToUser[msg.sender].bet==0) // bet = 0 will be the case when user hasn't participated in any previous bets
            addressToUser[msg.sender].balance=100;
        require(addressToUser[msg.sender].bet==0 || addressToUser[msg.sender].bet==3,"User already participated");
        require(addressToUser[msg.sender].balance>_amount,"Not enough funds");
        addressToUser[msg.sender].balance-=_amount;
        addressToUser[msg.sender].amount=_amount;
        if(_choice==1)
            addressToUser[msg.sender].bet = 1; //heads
        else
            addressToUser[msg.sender].bet = 2; //tails
        bettors.push(msg.sender);
    }

    function numberOfBettors() view public returns(uint){
        return bettors.length;
    }

    function retrieveBalance(address _addr) view public returns(uint){
        return addressToUser[_addr].balance;
    }

    function vrf() public view returns (bytes32 result) {
        uint[1] memory bn;
        bn[0] = block.number;
        assembly {
        let memPtr := mload(0x40)
        if iszero(staticcall(not(0), 0xff, bn, 0x20, memPtr, 0x20)) {
            invalid()
        }
        result := mload(memPtr)
        }
    }

    // The below function is to be made onlyOwner but
    // for testing purposes it has been left as it is.
    
    function rewardBet() external { //an onlyOwner Function
        uint rand = uint(vrf()); // VRF function comes here
        for(uint i=0;i<bettors.length;i++){
            if((rand%2)+1==addressToUser[bettors[i]].bet){
                addressToUser[bettors[i]].balance+=2*addressToUser[bettors[i]].amount;
                addressToUser[bettors[i]].amount=0;
            }
            addressToUser[bettors[i]].bet=3; // bet = 3 will be the case when user has participated             
        }
        for(uint i=0;i<bettors.length;i++){
            bettors.pop();
        }
    }
}
