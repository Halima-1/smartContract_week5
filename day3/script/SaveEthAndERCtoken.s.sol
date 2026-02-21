// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {SaveEthAndERCtoken} from "../src/SaveEthAndERCtoken.sol";

contract SaveEthAndERCtokenScript is Script {
    SaveEthAndERCtoken public saveethAndErCtoken;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        saveethAndErCtoken = new SaveEthAndERCtoken(0xDe9DdA8EC6812bdBb4611cddC8D503f7B27e69eE);

        vm.stopBroadcast(); 
    }
}
