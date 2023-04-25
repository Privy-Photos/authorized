// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { IAuthorized } from "./interfaces/IAuthorized.sol";

contract Authorized is IAuthorized {
    constructor() {
        /// @notice Add the deployer as an authorized admin
        authorizedAdmins[msg.sender] = true;
    }

    /// @notice A mapping storing authorized admins
    /// @dev admin address => authorized status
    mapping (address => bool) private authorizedAdmins;

    /// @notice A mapping of the authorized delegate operators
    /// @dev operator address => authorized status
    mapping (address => bool) private authorizedOperators;

    /// @dev Modifier to ensure caller is authorized admin
    modifier onlyAuthorizedAdmin() {
        if (!authorizedAdmins[msg.sender]) {
            revert Unauthorized();
        }
        _;
    }

    /// @dev Modifier to ensure caller is authorized operator
    modifier onlyAuthorizedOperator() {
        if (!authorizedOperators[msg.sender]) {
            revert Unauthorized();
        }
        _;
    }

    /// @inheritdoc IAuthorized
    function setAuthorizedAdmin(address _admin, bool status) public virtual onlyAuthorizedAdmin {
        /// check if address is not null
        require(_admin != address(0), "Authorized System: Admin address cannot be null");
        /// check if address is not the same as operator
        require(!authorizedOperators[_admin], "Authorized System: Admin cannot be an operator");
        /// check if address is human
        /// require(_admin == tx.origin, "Authorized System: Admin address must be human");
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
    function getAuthorizedAdmin(address _admin) external view virtual returns (bool) {
        return authorizedAdmins[_admin];
    }

    /// @inheritdoc IAuthorized
    function getAuthorizedOperator(address _operator) external view virtual returns (bool) {
        return authorizedOperators[_operator];
    }
}