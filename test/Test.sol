pragma solidity ^0.8.20;

import  "forge-std/Test.sol";
import "../src/SimpleStorage.sol";

abstract contract HelperContract {
    address constant IMPORTANT_ADDRESS = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;
    SimpleStorage simpleStorage;
    constructor(){

    }
}

contract SimpleStorageTest is Test,HelperContract {
    address alice = makeAddr("Alice");
    address bob = makeAddr("Bob");
    event NumberChanged (address indexed by, uint256 number);

    function setUp() public {
        simpleStorage = new SimpleStorage();
    }

    function test_NumberIs0() public {
        uint256 exeptedNumber = simpleStorage.getNumber();
        assertEq(exeptedNumber,0);
    }

    function testFail_SetNumberTo11() public{
        simpleStorage.setNumber(11);
    }

    function test_SetNumberTo9() public {
        uint256 exeptedNumber = simpleStorage.getNumber();
        assertEq(exeptedNumber,0);
        simpleStorage.setNumber(9);
        exeptedNumber = simpleStorage.getNumber();
        assertEq(exeptedNumber,9);
    }
    function test_SetNumberTo8WithBob() public {
        vm.prank(bob);
        uint256 exeptedNumber = simpleStorage.getNumber();
        assertEq(exeptedNumber,0);
        simpleStorage.setNumber(8);
        exeptedNumber = simpleStorage.getNumber();
        assertEq(exeptedNumber,8);

        vm.prank(alice);
        exeptedNumber = simpleStorage.getNumber();
        assertEq(exeptedNumber,0);
    }

    function test_RevertWhen_NumberOutOfRange() public {
        vm.prank(bob);
        vm.expectRevert(NumberOutOfRange.selector);
        simpleStorage.setNumber(13);
    }

    function test_ExpectEmit() public {
        vm.expectEmit(true , false,false,true);
        emit NumberChanged(address(bob),7);
        vm.prank(bob);
        simpleStorage.setNumber(7);
    }
}