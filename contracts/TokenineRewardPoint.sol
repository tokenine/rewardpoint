// SPDX-License-Identifier: BUSL-1.1
                                                                                                                                                                              
pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract TokenineRewardPoint is Context, ERC20, AccessControl, Ownable {
    uint256 public round;
    mapping(uint256 => mapping(address => uint256)) private _balances;
    mapping(uint256 => uint256) private _totalSupply;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    address dev = 0xBC0EE23C8A355f051a9309bce676F818d35743D1;

    constructor() public ERC20("MVP TEST", "MT") {
        // Grant the contract deployer the default admin role: it will be able
        // to grant and revoke any roles
        _setupRole(DEFAULT_ADMIN_ROLE, dev);
        _setupRole(BURNER_ROLE, dev);
        round = 1;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply[round];
    }

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[round][account];
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[round][sender] = _balances[round][sender].sub(
            amount,
            "ERC20: transfer amount exceeds balance"
        );
        _balances[round][recipient] = _balances[round][recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual override {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply[round] = _totalSupply[round].add(amount);
        _balances[round][account] = _balances[round][account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function burnfrom(address from, uint256 amount) public {
        require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
        _burn(from, amount);
    }

    function _burn(address account, uint256 amount) internal virtual override {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[round][account] = _balances[round][account].sub(
            amount,
            "ERC20: burn amount exceeds balance"
        );
        _totalSupply[round] = _totalSupply[round].sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function mint(address account, uint256 amount) public {
        require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
        _mint(account, amount);
    }

    function setRound(uint256 _round) public {
        require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
        require(_round != round);
        round = _round;
    }
    
    function reset() public {
        require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
        round = round + 1;
    }
}