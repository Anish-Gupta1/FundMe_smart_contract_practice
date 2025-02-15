// SPDX-License-Identifier: MIT 

pragma solidity 0.8.24;

import {PriceConvertor} from "./PriceConvertor.sol"; 


contract FundMe {
    using PriceConvertor for uint; 

    uint public minUsd = 5e18;

    address[] public funders;

    mapping(address funder => uint amt) public addressToAmtFunded ; 

    function fund() public payable {
        require(msg.value.getConversion() > minUsd, "Didnt send enough eth") ; 
        funders.push(msg.sender);
        addressToAmtFunded[msg.sender] += msg.value ; 
    }

    address public owner;
    constructor(){
        owner = msg.sender;
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
        require(msg.sender == owner , "Must be the owner.");
        _;
    }
}