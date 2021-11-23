pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 randomNumber;

    uint256 private seed;

    mapping(address => uint256) public waveMapping;
    /*
     * A little magic, Google what events are in Solodity!
     */
    event NewWave(address indexed from, uint256 timestamp, string message);

    /*
     * I created a struct here named Wave.
     * A struct is basically a custom datatype where we can customize what we want to hold inside it.
     */
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    /*
     * I declare a variable waves that lets me store an array of structs.
     * This is what lets me gold all the waves anyone ever sends to me!
     */
    Wave[] waves;
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("I can pay folks now");
    }

    /*
     * You'll notice I changed the wave function a little here as well and
     * now it requires a string called _message. This is the message out user
     * sends us from the frontend!
     */
    function wave(string memory _message) public {
        /** making the new time at least 15 minutes larger */
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );

        totalWaves += 1;
        waveMapping [msg.sender] += 1;
        console.log("%s has waved!", msg.sender);

        /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;

        /*
         * This is where I actually store the wave data in the array.
         */

        waves.push(Wave(msg.sender, _message, block.timestamp));

        /** 
        Creating a random number
        */
        
        randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %s", randomNumber);

        /**
        set the generated, random number as the seed for the next wave
         */

         seed = randomNumber;

         /**
         Give a 50% chance that a user wins the prize
          */

          if (randomNumber < 50){
              console.log ("%s won!", msg.sender);

              uint256 prizeAmount = 0.00001 ether;
                require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
                );
                (bool success, ) = (msg.sender).call{value: prizeAmount}("");
                require(success, "Failed to withdraw money from contract.");
            }

        /*
         * I added some fanciness here, Google it and try to figure out what it is!
         * Let me know what you learn in #course-chat
         */
        emit NewWave(msg.sender, block.timestamp, _message);

    }
    /*
     * I added a function getAllWaves which will return the struct array, waves, to us.
     * This will make it easy to retrieve the waves from our website!
     */
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }
    
    function getTotalWaves() public view returns (uint256){
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
    function getTotalWavesForAddress(address _add) public view returns (uint256){
        console.log("Getting waveCount for %s", _add);
        return waveMapping[_add];
    }

}