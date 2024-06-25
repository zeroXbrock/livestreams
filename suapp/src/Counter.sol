// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Suave} from "suave-std/suavelib/Suave.sol";

contract Counter {
    uint256 public number;

    event NumberSet(uint256 num);

    modifier confidential() {
        require(
            Suave.isConfidential(),
            "Only confidential transactions are allowed"
        );
        _;
    }

    function onSetNumber(uint256 num) public {
        number = num;
        emit NumberSet(num);
    }

    function setNumber() public confidential returns (bytes memory) {
        bytes memory inputs = Suave.confidentialInputs();
        uint256 newNumber = abi.decode(inputs, (uint256));
        return abi.encodeWithSelector(this.onSetNumber.selector, newNumber);
    }
}
