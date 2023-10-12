// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract IPOContract {
    string public companyName;
    uint256 public totalShares;
    uint256 public sharePrice;
    uint256 public sharesSold;
    ERC20 public paymentToken;

    mapping(address => uint256) public shareBalances;

    event SharesPurchased(address indexed buyer, uint256 sharesPurchased);
    event SharesRefunded(address indexed buyer, uint256 sharesRefunded);
    event CheckBalance(uint amount);

    constructor(
        string memory _companyName,
        uint256 _totalShares,
        uint256 _sharePrice,
        address _paymentToken
    ) {
        companyName = _companyName;
        totalShares = _totalShares;
        sharePrice = _sharePrice;
        paymentToken = ERC20(_paymentToken);
    }
    
    function purchaseShares(uint256 numShares) external payable {
        require(sharesSold + numShares <= totalShares, "Not enough shares available");
        uint256 cost = numShares * sharePrice;
        require(paymentToken.transferFrom(msg.sender, address(this), cost), "Token transfer failed");
        shareBalances[msg.sender] += numShares;
        sharesSold += numShares;
        emit SharesPurchased(msg.sender, numShares);
    }

    function refundShares(uint256 numShares) external {
        require(shareBalances[msg.sender] >= numShares, "Insufficient shares to refund");
        uint256 refundAmount = numShares * sharePrice;
        shareBalances[msg.sender] -= numShares;
        sharesSold -= numShares;
        require(paymentToken.transfer(msg.sender, refundAmount), "Token transfer failed");
        emit SharesRefunded(msg.sender, numShares);
    }

    function withdrawFunds() external onlyOwner {
        uint256 balance = paymentToken.balanceOf(address(this));
        require(paymentToken.transfer(owner(), balance), "Token transfer failed");
    }
    
    function getBalance(address user_account) external returns (uint){
       uint user_bal = user_account.balance;
       emit CheckBalance(user_bal);
       return (user_bal);
    }
}
