// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "@hyperlane-xyz/core/interfaces/IMailbox.sol";

contract HyperlaneMessageSender {
    IMailbox outbox;
    mapping(uint32 => uint256) public nonces;  // Mapping of destination domain to nonce

    event SentMessage(uint32 destinationDomain, bytes32 recipient, string message, uint256 nonce);

    constructor(address _outbox) {
        outbox = IMailbox(_outbox);
    }

    function sendString(
        uint32 _destinationDomain,
        bytes32 _recipient,
        string calldata _message
    ) external {
        // Retrieve the current nonce for the given destination domain
        uint256 nonce = nonces[_destinationDomain];

        // Generate a unique tag for the message using the nonce
        bytes32 tag = keccak256(abi.encodePacked(_recipient, nonce, _message));

        // Dispatch the message with the generated tag
        outbox.dispatch(_destinationDomain, tag, bytes(_message));

        // Emit the sent message event
        emit SentMessage(_destinationDomain, tag, _message, nonce);

        // Increment the nonce for the next message
        nonces[_destinationDomain]++;
    }
}