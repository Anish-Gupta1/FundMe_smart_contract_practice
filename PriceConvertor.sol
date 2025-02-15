// SPDX-License-Identifier: MIT 

pragma solidity 0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConvertor{
    function getConversion(uint ethAmount) internal view returns(uint){
        uint ethPrice = getPrice();
        uint ethToUsd = (ethAmount * ethPrice) / 1e18 ;
        return (ethToUsd);
    }

    function getPrice() internal view returns(uint){
        //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //ABI
        (,int256 price,,,) = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).latestRoundData();
        return uint(price * 1e10);
    }

    function getVersion() internal view returns(uint){
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}