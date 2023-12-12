// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import { IAuthorized } from "./interfaces/IAuthorized.sol";

abstract contract Authorized is IAuthorized {
    constructor() {
        /// @notice Add the deployer as an authorized admin
        owner = msg.sender;
    }

    /// @notice the owner of the contract
    address private owner;

    /// @notice A mapping storing authorized admins
    /// @dev admin address => authorized status
    mapping (address => bool) private authorizedAdmins;

    /// @notice A mapping of the authorized delegate operators
    /// @dev operator address => authorized status
    mapping (address => bool) private authorizedOperators;

    /// @notice Modifier to ensure caller is owner
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert Unauthorized();
        }
        _;
    }

    /// @dev Modifier to ensure caller is authorized admin
    modifier onlyAuthorizedAdmin() {
        if (msg.sender != owner && !authorizedAdmins[msg.sender]) {
            revert Unauthorized();
        }
        _;
    }

    /// @dev Modifier to ensure caller is authorized operator
    modifier onlyAuthorizedOperator() {
        if (msg.sender != owner && !authorizedAdmins[msg.sender] && !authorizedOperators[msg.sender]) {
            revert Unauthorized();
        }
        _;
    }

    /// @inheritdoc IAuthorized
    function transferOwnership(address newOwner) external onlyOwner {
        /// check if address is not null
        require(newOwner != address(0), "Authorized System: New owner cannot be null");
        /// check if address is not the same as owner
        require(newOwner != owner, "Authorized System: New owner cannot be the same as old owner");
        /// check if address is not the same as operator
        require(!authorizedOperators[owner], "Authorized System: Owner cannot be an operator");

        /// update the owner
        owner = newOwner;
    }

    /// @inheritdoc IAuthorized
    function setAuthorizedAdmin(address _admin, bool status) public virtual onlyAuthorizedAdmin {
        /// check if address is not null
        require(_admin != address(0), "Authorized System: Admin address cannot be null");
        /// check if address is not the same as operator
        require(!authorizedOperators[_admin], "Authorized System: Admin cannot be an operator");
        
        /// update the admin status
        authorizedAdmins[_admin] = status;
        emit SetAdmin(_admin);
    }

    /// @inheritdoc IAuthorized
    function setAuthorizedOperator(address _operator, bool status) public virtual onlyAuthorizedAdmin {
        /// check if address is not null
        require(_operator != address(0), "Authorized System: Operator address cannot be null");
        /// check if address is not the same as admin
        require(!authorizedAdmins[_operator], "Authorized System: Operator cannot be an admin");
        
        /// update the operator status
        authorizedOperators[_operator] = status;
        emit SetOperator(_operator);
    }

    /// @inheritdoc IAuthorized
    function getAuthorizedAdmin(address _admin) public view virtual returns (bool) {
        return authorizedAdmins[_admin];
    }

    /// @inheritdoc IAuthorized
    function getAuthorizedOperator(address _operator) public view virtual returns (bool) {
        return authorizedOperators[_operator];
    }

    /// @inheritdoc IAuthorized
    function getOwner() public view virtual override returns (address) {
        return owner;
    }
}