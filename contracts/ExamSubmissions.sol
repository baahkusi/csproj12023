// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./libraries/AutoMap.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract ExamSubmissions {
    address public admin;
    address public hod;
    mapping(address => bool) public lecturers;
    mapping(address => bool) public photocopiers;
    mapping(bytes => uint) public questionUrl;

    iqtmap questions;
    mapping(uint16 => itmap) internal levelQuestions;
    mapping(uint16 => itmap) internal yearQuestions;
    mapping(address => itmap) internal lecturerQuestions;
    mapping(string => itmap) internal courseQuestions;

    using AutoQuestionMapping for iqtmap;
    using AutoMapping for itmap;

    constructor(address _admin, address _hod) payable {
        admin = _admin;
        hod = _hod;
    }

    modifier onlyActor(address actor, string memory actorName) {
        require(
            msg.sender == actor,
            string.concat(
                "Unauthorized, Only",
                actorName,
                "Can Perform This Acton ..."
            )
        );
        _;
    }

    modifier onlyGroup(
        mapping(address => bool) storage group,
        address actor,
        string memory groupName
    ) {
        require(
            group[actor],
            string.concat(
                "Unauthorized, Only",
                groupName,
                "Can Perform This Acton ..."
            )
        );
        _;
    }

    modifier addGroupMembers(
        mapping(address => bool) storage group,
        address[] calldata actors,
        string memory groupName
    ) {
        for (uint256 i = 0; i < actors.length; i++) {
            group[actors[i]] = true;
        }
        _;
    }

    modifier removeGroupMembers(
        mapping(address => bool) storage group,
        address[] calldata actors,
        string memory groupName
    ) {
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

    function addLecturers(
        address[] calldata _lecturers
    )
        public
        onlyActor(admin, "Admin")
        addGroupMembers(lecturers, _lecturers, "lecturers")
    {}

    function addPhotocopiers(
        address[] calldata _photocopiers
    )
        public
        onlyActor(admin, "Admin")
        addGroupMembers(lecturers, _photocopiers, "photocopiers")
    {}

    function removeLecturers(
        address[] calldata _lecturers
    )
        public
        onlyActor(admin, "Admin")
        removeGroupMembers(lecturers, _lecturers, "lecturers")
    {}

    function removePhotocopiers(
        address[] calldata _photocopiers
    )
        public
        onlyActor(admin, "Admin")
        removeGroupMembers(lecturers, _photocopiers, "photocopiers")
    {}

    function addQuestion(
        bytes calldata _url,
        uint16 _level,
        uint16 _year,
        string calldata _course
    )
        public
        onlyGroup(lecturers, msg.sender, "lecturers")
        returns (uint index)
    {
        Question memory q = Question({
            url: _url,
            level: _level,
            year: _year,
            course: _course,
            lecturer: msg.sender
        });
        index = questions.add(q);
        questionUrl[_url] = index;
        lecturerQuestions[msg.sender].add(index);
        yearQuestions[_year].add(index);
        levelQuestions[_level].add(index);
        courseQuestions[_course].add(index);
    }

    function removeQuestionById(
        uint questionId
    ) public onlyGroup(lecturers, msg.sender, "lecturers") {
        require(
            lecturerQuestions[msg.sender].has(questionId),
            "Lecturer can't delete a questions they didn't upload ..."
        );
        IndexQuestionValue memory q = questions.get(questionId);
        require(q.exists, "Question doesn't exist ...");
        levelQuestions[q.value.level].del(questionId);
        yearQuestions[q.value.year].del(questionId);
        lecturerQuestions[msg.sender].del(questionId);
        courseQuestions[q.value.course].del(questionId);
        questions.del(questionId);
    }

    function removeQuestionByUrl(
        bytes calldata _url
    ) public onlyGroup(lecturers, msg.sender, "lecturers") {
        uint questionId = questionUrl[_url];
        removeQuestionById(questionId);
    }

    function getQuestionById(
        uint questionId
    ) public view returns (Question memory) {
        IndexQuestionValue memory q = questions.get(questionId);
        require(q.exists, "Question doesn't exist ...");
        return q.value;
    }

    function getQuestionById(
        bytes calldata _url
    ) public view returns (Question memory) {
        uint questionId = questionUrl[_url];
        return getQuestionById(questionId);
    }

    function questionsFromKeys(uint[] memory questionKeys) private view returns (Question[] memory qs) {
        qs = new Question[](questionKeys.length);
        for (uint256 i = 0; i < questionKeys.length; i++) {
            qs[i] = questions.get(questionKeys[i]).value;
        }
    }

    function getLevelQuestions(uint16 _level) public view returns (Question[] memory) {
        uint[] memory keys = levelQuestions[_level].all();
        return questionsFromKeys(keys);
    }

    function getYearQuestions(uint16 _year) public view returns (Question[] memory) {
        uint[] memory keys = yearQuestions[_year].all();
        return questionsFromKeys(keys);
    }

    function getCourseQuestions(string calldata _course) public view returns (Question[] memory) {
        uint[] memory keys = courseQuestions[_course].all();
        return questionsFromKeys(keys);
    }

    function getLecturerQuestions(address _lecturer) public view returns (Question[] memory) {
        uint[] memory keys = lecturerQuestions[_lecturer].all();
        return questionsFromKeys(keys);
    }
}
