// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {SaveEthAndERCtoken} from "../src/SaveEthAndERCtoken.sol";

contract SaveScript is Script {
    SaveEthAndERCtoken public save;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        save = new SaveScript();

        vm.stopBroadcast();
    }
}
