// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./TokenineRewardPoint.sol";


contract MVPDonate is ERC20("Stake MDD", "ST-MDD") {
    using SafeMath for uint256;
    IERC20 public mvp;
    TokenineRewardPoint public mvpp;
    
    // uint256 public endDate = 1635526860; //  Saturday, October 30, 2021 0:01:00 GMT+07:00
    uint256 public endDate = 1638032460; //  Saturdayที่ 27 November 2021 0:01:00 GMT+07:00
    address public donateTo  = 0xcD64a1fb76085F6184C1A8592f44DcF713EAD517 ;         
    constructor(IERC20 _mvp, TokenineRewardPoint _mvpp) public {
        mvp = _mvp;
        mvpp = _mvpp;
    }

    function currentTime() virtual internal view returns (uint256) {
        return now;
    }

    function calculateRewardPoint14days(uint256 _amount) public view returns (uint256) {
        uint256 timeDelta = endDate > currentTime() ? endDate - currentTime() : 0;
        timeDelta = timeDelta >= 14 days ? 14 days : timeDelta;        
        return _amount.mul(timeDelta).div(1 days).div(200);
    }

    function calculateRewardPoint(uint256 _amount) public view returns (uint256) {
        uint256 timeDelta = endDate > currentTime() ? endDate - currentTime() : 0;
        timeDelta = timeDelta >= 28 days ? 28 days : timeDelta;        
        return _amount.mul(timeDelta).div(1 days).div(400);
    }

    function enter(uint256 _amount) public {
        require(endDate > currentTime(), "ERC20: Timeout");
        uint256 totalMVP = mvp.balanceOf(address(this));
        uint256 totalShares = totalSupply();
        if (totalShares == 0 || totalMVP == 0) {
            _mint(msg.sender, _amount);
        } 
        else {
            uint256 what = _amount.mul(totalShares).div(totalMVP);
            _mint(msg.sender, what);
        }
        mvpp.mint(msg.sender, calculateRewardPoint(_amount).mul(90).div(100));
        mvpp.mint(donateTo, calculateRewardPoint(_amount).mul(10).div(100));
        mvp.transferFrom(msg.sender, address(this), _amount);
    }

    function leave(uint256 _share) public {
        require(endDate <= currentTime(), "ERC20: Unlock on July 10, 2021 5:30:32 PM GMT+07:00");
        uint256 totalMVP = mvp.balanceOf(address(this));
        uint256 totalShares = totalSupply();        
        uint256 what = _share.mul(totalMVP).div(totalShares);
        _burn(msg.sender, _share);
        mvp.transfer(msg.sender, what);
    }
}
