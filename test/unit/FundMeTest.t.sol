// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 AMOUNT = 0.1 ether;
    uint256 STARTING_BALANCE = 10 ether;
    uint256 constant GASPRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinUSD() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwner() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersion() public view {
        uint256 v = fundMe.getVersion();
        assertEq(v, 4);
    }

    function testFundFailWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesBalance() public {
        vm.prank(USER);
        fundMe.fund{value: AMOUNT}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, AMOUNT);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);

        fundMe.fund{value: AMOUNT}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: AMOUNT}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        uint256 balanceBefore = fundMe.getOwner().balance;
        uint256 fundMeBalanceBefore = address(fundMe).balance;

        // uint256 gasStart = gasleft();
        // vm.txGasPrice(GASPRICE);

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // uint256 gasUsed = (gasStart - gasleft()) * tx.gasprice;
        // console.log(gasUsed);

        uint256 balanceAfter = fundMe.getOwner().balance;
        uint256 fundMeBalanceAfter = address(fundMe).balance;
        assertEq(fundMeBalanceAfter, 0);
        assertEq(balanceAfter, balanceBefore + fundMeBalanceBefore);
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), AMOUNT);
            fundMe.fund{value: AMOUNT}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(
            fundMe.getOwner().balance ==
                startingOwnerBalance + startingFundMeBalance
        );
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), AMOUNT);
            fundMe.fund{value: AMOUNT}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(
            fundMe.getOwner().balance ==
                startingOwnerBalance + startingFundMeBalance
        );
    }
}
