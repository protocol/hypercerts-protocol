# Solidity API

## HypercertMinterV0

Contains functions and events to initialize and issue a hypercertificate

### \_version

```solidity
uint16 _version
```

Current version of the contract

### UPGRADER_ROLE

```solidity
bytes32 UPGRADER_ROLE
```

User role required in order to upgrade the contract

### counter

```solidity
uint256 counter
```

Counter incremented to form the hypercertificate id

### workScopes

```solidity
mapping(bytes32 => string) workScopes
```

Mapping of id's to work-scopes

### impactScopes

```solidity
mapping(bytes32 => string) impactScopes
```

Mapping of id's to impact-scopes

### rights

```solidity
mapping(bytes32 => string) rights
```

Mapping of id's to rights

### contributorImpacts

```solidity
mapping(address => mapping(bytes32 => bool)) contributorImpacts
```

Mapping of contributor addresses to impact-scopes

### impactCerts

```solidity
mapping(uint256 => struct HypercertMinterV0.Claim) impactCerts
```

Mapping of id's to hypercertificates

### Claim

```solidity
struct Claim {
  bytes32 claimHash;
  address[] contributors;
  uint256[2] workTimeframe;
  uint256[2] impactTimeframe;
  bytes32[] workScopes;
  bytes32[] impactScopes;
  bytes32[] rights;
  uint256 version;
  bool exists;
}

```

### ImpactClaimed

```solidity
event ImpactClaimed(uint256 id, bytes32 claimHash, address[] contributors, uint256[2] workTimeframe, uint256[2] impactTimeframe, bytes32[] workScopes, bytes32[] impactScopes, bytes32[] rights, uint256 version, string uri)
```

Emitted when an impact is claimed.

| Name            | Type       | Description                                           |
| --------------- | ---------- | ----------------------------------------------------- |
| id              | uint256    | Id of the claimed impact.                             |
| claimHash       | bytes32    | Hash value of the claim data.                         |
| contributors    | address[]  | Contributors to the claimed impact.                   |
| workTimeframe   | uint256[2] | To/from date of the work related to the claim.        |
| impactTimeframe | uint256[2] | To/from date of the claimed impact.                   |
| workScopes      | bytes32[]  | Id's relating to the scope of the work.               |
| impactScopes    | bytes32[]  | Id's relating to the scope of the impact.             |
| rights          | bytes32[]  | Id's relating to the rights applied to the hypercert. |
| version         | uint256    | Version of the hypercert.                             |
| uri             | string     | URI of the metadata of the hypercert.                 |

### ImpactScopeAdded

```solidity
event ImpactScopeAdded(bytes32 id, string text)
```

Emitted when a new impact scope is added.

| Name | Type    | Description                          |
| ---- | ------- | ------------------------------------ |
| id   | bytes32 | Id of the impact scope.              |
| text | string  | Short text code of the impact scope. |

### RightAdded

```solidity
event RightAdded(bytes32 id, string text)
```

Emitted when a new right is added.

| Name | Type    | Description                   |
| ---- | ------- | ----------------------------- |
| id   | bytes32 | Id of the right.              |
| text | string  | Short text code of the right. |

### WorkScopeAdded

```solidity
event WorkScopeAdded(bytes32 id, string text)
```

Emitted when a new work scope is added.

| Name | Type    | Description                        |
| ---- | ------- | ---------------------------------- |
| id   | bytes32 | Id of the work scope.              |
| text | string  | Short text code of the work scope. |

### constructor

```solidity
constructor() public
```

constructor logic

### initialize

```solidity
function initialize() public
```

Initialization logic

### addImpactScope

```solidity
function addImpactScope(string text) public returns (bytes32 id)
```

adds a new impact scope

| Name | Type   | Description                        |
| ---- | ------ | ---------------------------------- |
| text | string | text representing the impact scope |

| Name | Type    | Description            |
| ---- | ------- | ---------------------- |
| id   | bytes32 | id of the impact scope |

### addRight

```solidity
function addRight(string text) public returns (bytes32 id)
```

adds a new right

| Name | Type   | Description                 |
| ---- | ------ | --------------------------- |
| text | string | text representing the right |

| Name | Type    | Description     |
| ---- | ------- | --------------- |
| id   | bytes32 | id of the right |

### addWorkScope

```solidity
function addWorkScope(string text) public returns (bytes32 id)
```

adds a new work scope

| Name | Type   | Description                      |
| ---- | ------ | -------------------------------- |
| text | string | text representing the work scope |

| Name | Type    | Description          |
| ---- | ------- | -------------------- |
| id   | bytes32 | id of the work scope |

### mint

```solidity
function mint(address account, uint256 amount, bytes data) public
```

mints a new hypercert

| Name    | Type    | Description                                           |
| ------- | ------- | ----------------------------------------------------- |
| account | address | account minting the new hypercert                     |
| amount  | uint256 | amount of the new token to mint                       |
| data    | bytes   | data representing the parameters of the new hypercert |

### getImpactCert

```solidity
function getImpactCert(uint256 claimID) public view returns (struct HypercertMinterV0.Claim)
```

gets the hypercert with the specified id

| Name    | Type    | Description     |
| ------- | ------- | --------------- |
| claimID | uint256 | id of the claim |

| Name | Type                           | Description         |
| ---- | ------------------------------ | ------------------- |
| [0]  | struct HypercertMinterV0.Claim | claim, if it exists |

### uri

```solidity
function uri(uint256 tokenId) public view returns (string)
```

auto-generated by https://docs.openzeppelin.com/contracts/4.x/wizard

_selects which base implementation to call_

| Name    | Type    | Description     |
| ------- | ------- | --------------- |
| tokenId | uint256 | id of the token |

| Name | Type   | Description      |
| ---- | ------ | ---------------- |
| [0]  | string | URI of the token |

### version

```solidity
function version() public pure virtual returns (uint256)
```

gets the current version of the contract

| Name | Type    | Description             |
| ---- | ------- | ----------------------- |
| [0]  | uint256 | version of the contract |

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

returns a flag indicating if the contract supports the specified interface

| Name        | Type   | Description         |
| ----------- | ------ | ------------------- |
| interfaceId | bytes4 | id of the interface |

| Name | Type | Description                         |
| ---- | ---- | ----------------------------------- |
| [0]  | bool | true, if the interface is supported |

### \_authorizeUpgrade

```solidity
function _authorizeUpgrade(address newImplementation) internal
```

upgrade authorization logic

_adds onlyRole(UPGRADER_ROLE) requirement_

### \_beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address operator, address from, address to, uint256[] ids, uint256[] amounts, bytes data) internal
```

auto-generated by https://docs.openzeppelin.com/contracts/4.x/wizard

_selects which base implementation to call_

### \_storeContributorsClaims

```solidity
function _storeContributorsClaims(bytes32 claimHash, address[] creators) internal
```

stores contributor claims in the `contributorImpacts` mapping; guards against overlapping claims

### \_hash

```solidity
function _hash(string value) internal pure returns (bytes32)
```

hash the specified string value

| Name  | Type   | Description    |
| ----- | ------ | -------------- |
| value | string | string to hash |

| Name | Type    | Description           |
| ---- | ------- | --------------------- |
| [0]  | bytes32 | a keccak256 hash-code |

### \_hasKey

```solidity
function _hasKey(mapping(bytes32 => string) map, bytes32 key) internal view returns (bool)
```

checks whether the supplied mapping contains the supplied key

| Name | Type                               | Description       |
| ---- | ---------------------------------- | ----------------- |
| map  | mapping(bytes32 &#x3D;&gt; string) | mapping to search |
| key  | bytes32                            | key to search     |

| Name | Type | Description                            |
| ---- | ---- | -------------------------------------- |
| [0]  | bool | true, if the key exists in the mapping |

## HypercertMinterUpgrade

### Split

```solidity
event Split(uint256 fromID, uint256[] toID)
```

### split

```solidity
function split(uint256 id) public
```

### version

```solidity
function version() public pure virtual returns (uint256)
```

gets the current version of the contract

| Name | Type    | Description             |
| ---- | ------- | ----------------------- |
| [0]  | uint256 | version of the contract |