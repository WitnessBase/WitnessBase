// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@account-abstraction/contracts/core/EntryPoint.sol";
import "@account-abstraction/contracts/interfaces/IAccount.sol";
import "./TSD.sol";
import {ISP} from "@ethsign/sign-protocol-evm/src/interfaces/ISP.sol";
import {Attestation} from "@ethsign/sign-protocol-evm/src/models/Attestation.sol";
import {DataLocation} from "@ethsign/sign-protocol-evm/src/models/DataLocation.sol";

contract Account is IAccount {
    ISP public spInstance=ISP(0x4e4af2a21ebf62850fD99Eb6253E1eFBb56098cD);
    uint64 public schemaId;
    uint256 public count;
    address public owner;
    string public userName="Emojan";
    TSD public lastTSD;

    event Log(string message);

    constructor(address _owner, string memory _userName) {
        owner = _owner;
        userName = _userName;
    }

    
    
    function validateUserOp(
        PackedUserOperation calldata,
        bytes32,
        uint256
    ) external virtual override returns (uint256 validationData) {
        return 0;
    }
    function createTSD(
        string memory _projectName,
        string memory _projectDescription,
        string memory _dataURI
    ) public returns (address) {
        lastTSD = new TSD(
            userName,
            _projectName,
            _projectDescription,
            _dataURI
        );
        return address(lastTSD);
    }

    function attestTSD()  external returns (uint64){
        Attestation memory a = Attestation({
            schemaId: 3,
            linkedAttestationId: 0,
            attestTimestamp: 0,
            revokeTimestamp: 0,
            attester: address(this),
            validUntil: 0,
            dataLocation: DataLocation.ONCHAIN,
            revoked: false,
            recipients: new bytes[](0),
            data: abi.encode("exp") 
        });
       
       

       uint64 attestationId =  spInstance.attest(a, "bok", "0x", "0x");
       return attestationId;
    }

    function tryAttestTSD() public  returns (uint64){
        
    }
}

contract AccountFactory {
    event AccountCreated(address account, address owner);

    function createAccount(
        address owner,
        string memory userName
    ) public returns (address) {
        Account account = new Account(owner, userName);
        emit AccountCreated(address(account), owner);
        return address(account);
    }
}
