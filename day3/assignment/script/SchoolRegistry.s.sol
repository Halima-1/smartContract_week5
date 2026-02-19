// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {SchoolRegistry} from "../src/SchoolRegistry.sol";

contract SchoolRegistryScript is Script {
    SchoolRegistry public schoolregistry;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        schoolregistry = new SchoolRegistry(0x5D527ff9De9B001D7f341a4D6A4Df5Cfa64A901b);

        vm.stopBroadcast();
    }
}
