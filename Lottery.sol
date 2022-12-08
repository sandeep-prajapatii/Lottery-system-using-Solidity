//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <=0.9.0;

///@title A Lottery Game!

contract Lottery{
///@notice  Who manages the game here or starts the game is manager
    address public manager;
    address payable[] public participants;

    constructor(){
        manager = msg.sender;
    }

///@notice recieve function is to get the initial amount to get part in the game
    receive() external payable{
        require(msg.value == 1 ether);
        participants.push(payable(msg.sender));
    }

///@notice To see the total amount and only the manager can use this function
    function getBalance() public view returns(uint){
        require(msg.sender == manager, "Only Manager can see the balance");
        return address(this).balance;
    }

///@notice To generate a random value for selecting the winner
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

///@notice This function calls all the functions and also selects the winner on the basis of random()
///@notice Only the manager can call this function
    function selectWinner() public {
        require(msg.sender == manager, "Only Manager can start  the game");
        require(participants.length >=3, "Participants are less than three"); 
        uint r = uint(random());
        uint index = r % participants.length;
        address payable winner;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
}