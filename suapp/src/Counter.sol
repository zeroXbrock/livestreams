// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Suave} from "suave-std/suavelib/Suave.sol";

contract Counter {
    uint256 public number;

    event NumberSet(uint256 number);

    modifier confidential() {
        require(Suave.isConfidential(), "Counter: not confidential");
        _;
    }

    function onSetNumber(uint256 newNumber) public {
        number = newNumber;
        emit NumberSet(newNumber);
    }

    function setNumber() public confidential returns (bytes memory) {
        bytes memory data = Suave.confidentialInputs();
        uint256 newNumber = abi.decode(data, (uint256));
        return abi.encodeWithSelector(this.onSetNumber.selector, newNumber);
    }
}
