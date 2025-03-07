// SPDX-License-Identifier: MIT 

pragma solidity 0.8.24;

import {PriceConvertor} from "./PriceConvertor.sol"; 

error NotOwner();

contract FundMe {
    using PriceConvertor for uint; 

    uint public constant MIN_USD = 5e18;

    address[] public funders;

    mapping(address funder => uint amt) public addressToAmtFunded ; 

    function fund() public payable {
        require(msg.value.getConversion() > MIN_USD, "Didnt send enough eth") ; 
        funders.push(msg.sender);
        addressToAmtFunded[msg.sender] += msg.value ; 
    }

    address public immutable i_owner;
    
    constructor(){
        i_owner = msg.sender;
    }

    function Withdraw() public onlyOwner {
        for (uint funderIndex=0 ; funderIndex< funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmtFunded[funder] = 0;
        }
        //reset funders list
        funders = new address[](0);
        //withdraw
        
        //using transfer
        // payable (msg.sender).transfer(address(this).balance);
        
        //using send
        // bool isSend = payable(msg.sender).send(address(this).balance);
        // require(isSend , "Send failed.");

        //using call
        (bool isCall,) = payable(msg.sender).call{value: address(this).balance}("");
        require(isCall, "Call failed");
    }

    modifier onlyOwner(){
        // require(msg.sender == i_owner , "Must be the owner.");
        if(msg.sender != i_owner ){
            revert NotOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}