// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface IAuthorized {

    /// @notice Generic error when a user attempts to access a feature/function without proper access
    error Unauthorized();

    /// @notice Event emitted when a new admin is added
    event SetAdmin(address indexed admin);

    /// @notice Event emitted when a new operator is added
    event SetOperator(address indexed operator);

    /// @notice Event emmited when a new authOperator is added
    event SetAuthOperator(address indexed authOperator);

    /// @notice Transfer ownership of the contract to a new account (`newOwner`).
    /// @param newOwner The address to transfer ownership to.
    function transferOwnership(address newOwner) external;

    /// @notice Add an authorized admin
    /// @param _admin address of the admin
    /// @param status status of the admin
    function setAuthorizedAdmin(address _admin, bool status) external;

    /// @notice Add an authorized Operator
    /// @param _operator address of the operator
    /// @param status status of the operator
    function setAuthorizedOperator(address _operator, bool status) external;

    /// @notice Get the status of an admin
    /// @param _admin address of the admin
    /// @return status of the admin
    function getAuthorizedAdmin(address _admin) external view returns (bool);

    /// @notice Get the status of an operator
    /// @param _operator address of the operator
    /// @return status of the operator
    function getAuthorizedOperator(address _operator) external view returns (bool);

    /// @notice Get the owner
    function getOwner() external view returns (address);
}