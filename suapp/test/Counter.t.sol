// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";
import {SuaveEnabled} from "suave-std/Test.sol";
import {Suave} from "suave-std/suavelib/Suave.sol";

contract CounterTest is Test, SuaveEnabled {
    Counter public counter;
    // function setUp() public {
    //     counter = new Counter();
    //     counter.setNumber();
    // }
    function test_setNumber() public {
        // counter = new Counter();
        // counter.setNumber();
        // assertEq(counter.number(), 0);
        /*
            string url;
            string method;
            string[] headers;
            bytes body;
            bool withFlashbotsSignature;
        */
        Suave.HttpRequest memory req = Suave.HttpRequest({
            url: "https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd",
            method: "GET",
            headers: new string[](0),
            body: "",
            withFlashbotsSignature: false
        });
        Suave.doHTTPRequest(req);
    }
    // function testFuzz_SetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
