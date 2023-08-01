// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract ExamSubmissions {
    struct Question {
        string url;
    }
    address public admin;
    address public hod;
    mapping( address => bool ) lecturers;
    mapping( address => bool ) photocopiers;
    // course -> year -> level -> question
    mapping( string => mapping( uint16 => mapping( uint16 => Question ))) questions;

    constructor(address _admin, address _hod) payable {
        admin = _admin;
        hod = _hod;
    }

    modifier onlyActor(address actor, string memory actorName) {
        require(msg.sender == actor, string.concat("Unauthorized, Only", actorName, "Can Perform This Acton ..."));
        _;
    }

    modifier onlyGroup(mapping( address => bool ) storage group, address actor, string memory groupName) {
        require(group[actor], string.concat("Unauthorized, Only", groupName, "Can Perform This Acton ..."));
        _;
    }

    modifier addGroupMembers(mapping( address => bool ) storage group, address[] calldata actors, string memory groupName) {
        for (uint256 i = 0; i < actors.length; i++) {
            group[actors[i]] = true;
        }
        _;
    }

    modifier removeGroupMembers(mapping( address => bool ) storage group, address[] calldata actors, string memory groupName) {
        for (uint256 i = 0; i < actors.length; i++) {
            group[actors[i]] = false;
        }
        _;
    }

    function changeHod(address _hod) public onlyActor(admin, "Admin") {
        hod = _hod;
    }

    function changeAdmin(address _admin) public onlyActor(admin, "Admin") {
        admin = _admin;
    }

    function addLecturers(address[] calldata _lecturers) public onlyActor(admin, "Admin") addGroupMembers(lecturers, _lecturers, "lecturers") {
        
    }

    function addPhotocopiers(address[] calldata _photocopiers) public onlyActor(admin, "Admin") addGroupMembers(lecturers, _photocopiers, "photocopiers") {
        
    }

    function removeLecturers(address[] calldata _lecturers) public onlyActor(admin, "Admin") removeGroupMembers(lecturers, _lecturers, "lecturers") {
        
    }

    function removePhotocopiers(address[] calldata _photocopiers) public onlyActor(admin, "Admin") removeGroupMembers(lecturers, _photocopiers, "photocopiers") {
        
    }
}
