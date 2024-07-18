// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Suave} from "suave-std/suavelib/Suave.sol";
import {Suapp} from "suave-std/Suapp.sol";
import {Context} from "suave-std/Context.sol";
import {Random} from "suave-std/Random.sol";

contract Counter is Suapp {
    uint256 public number;

    event NumberSet(uint256 number);

    modifier confidential() {
        require(Suave.isConfidential(), "Counter: not confidential");
        _;
    }

    function onSetNumber(uint256 newNumber) public emitOffchainLogs {
        number = newNumber;
        emit NumberSet(newNumber);
    }

    function onDoStuff(uint256 n) public emitOffchainLogs {
        number = n;
    }

    function doLotsOfStuff() public confidential returns (bytes memory) {
        uint256 n = 42;
        uint256 c = 43;
        uint256 v = 44;
        uint256 x = 45;
        uint256 b = 47;

        emit NumberSet(n);
        emit NumberSet(c);
        emit NumberSet(v);
        emit NumberSet(x);
        emit NumberSet(b);

        return abi.encodeWithSelector(this.onDoStuff.selector, n);
    }

    function setNumber() public confidential returns (bytes memory) {
        bytes memory data = Context.confidentialInputs();
        uint256 newNumber = abi.decode(data, (uint256));
        return abi.encodeWithSelector(this.onSetNumber.selector, newNumber);
    }

    function setWithRandomNumber() public confidential returns (bytes memory) {
        uint256 newNumber = Random.randomUint256();
        return abi.encodeWithSelector(this.onSetNumber.selector, newNumber);
    }

    function setToVitalikBalance() public confidential returns (bytes memory) {
        address v = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
        address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

        bytes memory rawBalance = Suave.ethcall(
            weth,
            abi.encodeWithSignature("balanceOf(address)", v)
        );
        uint256 balance = abi.decode(rawBalance, (uint256));
        return abi.encodeWithSelector(this.onSetNumber.selector, balance);
    }
}
