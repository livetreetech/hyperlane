// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "@hyperlane-xyz/core/interfaces/IMailbox.sol";

contract HyperlaneMessageReceiver {
    IMailbox inbox;
    bytes32 public lastSender;
    string public lastMessage;
    mapping(uint32 => mapping(bytes32 => bool)) public processedMessages;

    event ReceivedMessage(uint32 origin, bytes32 sender, bytes message);
    event ErrorMessage(string message);

    constructor(address _inbox) {
        inbox = IMailbox(_inbox);
    }

    function handle(
        uint32 _origin,
        bytes32 _sender,
        bytes calldata _message
    ) external {
        // Generate a unique identifier for this message based on origin and sender
        bytes32 messageID = keccak256(abi.encodePacked(_origin, _sender, _message));

        // Check if the message has already been processed
        // TO DO ADD MESSAGE BODY CHECK THIS ONLY ADDS MESSSAGE UNIUQENESS
        if (processedMessages[_origin][_sender]) {
            emit ErrorMessage("This message has already been processed");
            return;
        }

        // Mark the message as processed
        processedMessages[_origin][_sender] = true;

        // Update state variables
        lastSender = _sender;
        lastMessage = string(_message);

        // Emit the received message event
        emit ReceivedMessage(_origin, _sender, _message);
    }
}