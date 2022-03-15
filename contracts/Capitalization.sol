// SPDX-License-Identifier: MIT

pragma solidity ^0.6.8;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./RepToken.sol";

contract Capitalization {
    using SafeMath for uint256;

    string public poolName;
    uint256 public noOfInvestorsJoined;
    uint256 public fundBalance;
    uint256 public fundMaxAmount;
    uint256 public minimumContributionAmount;
    uint256 public contributionIncrementAmount;
    address public manager;

    struct Investor {
        bool hasJoined;
        uint256 contributionAmount;
    }

    mapping(address => Investor) public investors;

    RepToken repToken = new RepToken(
        "ChitUnderwriterToken",
        "CUT",
         0 // By deploying this contract, there will be no tokens created initially (until minted later), but this contract will be the default admin
    );

    function joinFund() public {
        require(
            !investors[msg.sender].hasJoined, "You are already part of the current fund"
        );
        investors[msg.sender].hasJoined = true;
        noOfInvestorsJoined++;
    }

    function contribute() public payable {
        require( msg.value > minimumContributionAmount,
            "You are attempting to contribute an amount into the fund that is less than the minimum amount, you must at least contribute the minimum amount"
        );
        require( msg.value < fundMaxAmount,
            "You are attempting to contribute an amount that is above the maximum amount the fund is seeking for capitalization, please reduce your contribution amount"
        );
        require( msg.value % 1 ether != 0, // check if contribution is in increment of exactly 1 eth
            "You are attempting to contribute an amount that is not an increment of 1 ETH, please contribute in increments of 1 ETH"
        );
        if (investors[msg.sender].hasJoined == false) {
            joinFund();
        }
        fundBalance += msg.value;
        investors[msg.sender].contributionAmount += msg.value;
        repToken.mint(msg.sender, msg.value);  // mint an equal amount of rep token to correspond with the amount of eth contributed
    }

    constructor(
        string memory _poolName,
        uint256 _fundMaxAmount,
        uint256 _minimumContributionAmount,
        uint256 _contributionIncrementAmount
    ) public {
        poolName = _poolName;
        fundMaxAmount = _fundMaxAmount;
        minimumContributionAmount = _minimumContributionAmount * 1e18; // 1e18 = 1eth, or 10000000000000000 wei
        contributionIncrementAmount = _contributionIncrementAmount * 1e18;
        manager = msg.sender;  //TODO: consider adding this to constructor to make it configurable?
    }


}