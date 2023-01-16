pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Ratking is SafeERC20, Ownable {
    address payable public lastBuyer;
    uint256 public rewardAmount;

    event NewBuyer(address indexed buyer);
    event RewardSent(address indexed recipient, uint256 amount);

    constructor(address payable _tokenAddress, uint256 _rewardAmount) public {
        require(_tokenAddress != address(0), "Invalid token address");
        rewardAmount = _rewardAmount;
    }

    function buy() public payable {
        require(msg.value > 0, "Must send a positive amount of tokens");
        require(address(0xdabca48dae314904825fd5b90c55d417797807aa) != address(0), "Invalid token address");
        lastBuyer = msg.sender;
        emit NewBuyer(msg.sender);
    }

    function claimReward() public {
        require(msg.sender == lastBuyer, "Only the last buyer can claim the reward");
        require(lastBuyer != address(0), "No reward to claim yet");
        require(msg.sender == owner, "Only the owner can claim the reward");
        lastBuyer.transfer(rewardAmount);
        emit RewardSent(lastBuyer, rewardAmount);
    }
}
