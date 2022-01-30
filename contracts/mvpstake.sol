// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./TokenineRewardPoint.sol";

contract MVPStake is ERC20("Stake MD", "ST-MD") {
  using SafeMath for uint256;
  IERC20 public mvp;
  TokenineRewardPoint public mvpp;

  uint256 public endDate = 1643562060; // Monday, January 31, 2022 00:01:00 GMT+07:00

  constructor(IERC20 _mvp, TokenineRewardPoint _mvpp) public {
    mvp = _mvp;
    mvpp = _mvpp;
  }

  function currentTime() internal view virtual returns (uint256) {
    return now;
  }

  function calculateRewardPoint(uint256 _amount) public view returns (uint256) {
    uint256 timeDelta = endDate > currentTime() ? endDate - currentTime() : 0;
    timeDelta = timeDelta >= 25 days ? 25 days : timeDelta;
    return _amount.mul(timeDelta).div(1 days).div(400);
  }

  function enter(uint256 _amount) public {
    require(endDate > currentTime(), "ERC20: Timeout");
    uint256 totalMVP = mvp.balanceOf(address(this));
    uint256 totalShares = totalSupply();
    if (totalShares == 0 || totalMVP == 0) {
      _mint(msg.sender, _amount);
    } else {
      uint256 what = _amount.mul(totalShares).div(totalMVP);
      _mint(msg.sender, what);
    }
    mvpp.mint(msg.sender, calculateRewardPoint(_amount));
    mvp.transferFrom(msg.sender, address(this), _amount);
  }

  function leave(uint256 _share) public {
    require(
      endDate <= currentTime(),
      "ERC20: Unlock on Monday, January 31, 2022 00:01:00 GMT+07:00"
    );
    uint256 totalMVP = mvp.balanceOf(address(this));
    uint256 totalShares = totalSupply();
    uint256 what = _share.mul(totalMVP).div(totalShares);
    _burn(msg.sender, _share);
    mvp.transfer(msg.sender, what);
  }
}
