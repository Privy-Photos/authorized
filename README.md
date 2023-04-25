# Authorized

This package is an extension to to be used to register/manage Admins and operators to control the desired functions in a Smart Contract. 

Install:

```shell
npm install @privylabs/authorized
yarn add @privylabs/authorized
```

Usage:
```shell
import { Authorized } from "@privylabs/authorized/contracts/Authorized.sol";
```

The deployer waller will be registered as the root Admin
```shell
constructor() {
        /// @notice Add the deployer as an authorized admin
        authorizedAdmins[msg.sender] = true;
    }
```
More admins can be managed at:

```shell
setAuthorizedAdmin(address _admin, bool status)
```

To magane Operators:

```shell
setAuthorizedOperator(address _operator, bool status)
```

Use the modifiers ```onlyAuthorizedAdmin onlyAuthorizedOperator``` to secure functions:


```shell
function foo( string  _var ) external onlyAuthorizedOperator ...