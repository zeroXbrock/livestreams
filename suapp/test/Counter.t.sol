// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {Counter} from "../src/Counter.sol";
import {SuaveEnabled} from "suave-std/Test.sol";

contract CounterTest is Test, SuaveEnabled {
    function removeFunctionSelector(
        bytes memory data
    ) public pure returns (uint256 value) {
        require(data.length >= 36, "Invalid calldata length");
        assembly {
            // Convert the bytes memory to bytes32 to read the uint256 value
            // The first 32 bytes of a bytes memory array contain the length, so we skip 32 (length) + 4 (selector)
            value := mload(add(data, 36))
        }
    }

    function testCounter() public {
        Counter counter = new Counter();
        ctx.setConfidentialInputs(abi.encode(42));
        bytes memory setNumberResult = counter.setNumber();
        console2.logBytes(setNumberResult);
        uint256 n = removeFunctionSelector(setNumberResult);
        assertEq(n, 42);

        counter.onSetNumber(43);
        uint256 number = counter.number();
        assertEq(number, 43);
    }

    function testRandomCounter() public {
        Counter counter = new Counter();
        bytes memory setNumberResult = counter.setWithRandomNumber();
        uint256 n = removeFunctionSelector(setNumberResult);
        console2.log("random", n);
        assert(n != 42);
    }

    function testEthCallNumber() public {
        Counter counter = new Counter();
        bytes memory setNumberResult = counter.setToVitalikBalance();
        uint256 n = removeFunctionSelector(setNumberResult);
        console2.log("vitalik balance", n);
        assert(n > 0);
    }

    function testDoLotsOfStuff() public {
        Counter counter = new Counter();
        bytes memory doLotsOfStuffResult = counter.doLotsOfStuff();
        uint256 n = removeFunctionSelector(doLotsOfStuffResult);
        console2.log("doLotsOfStuff", n);
        assert(n == 42);
    }
}
