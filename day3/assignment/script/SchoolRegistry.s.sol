// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {SchoolRegistry} from "../src/SchoolRegistry.sol";

contract SchoolRegistryScript is Script {
    SchoolRegistry public schoolregistry;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        schoolregistry = new SchoolRegistry(0xDe9DdA8EC6812bdBb4611cddC8D503f7B27e69eE);

        vm.stopBroadcast();
    }
}
