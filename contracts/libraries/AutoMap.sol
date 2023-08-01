// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

struct IndexValue { bool exists; uint value; }

struct itmap {
    mapping(uint => IndexValue) data;
    uint[] deletedKeys;
    uint size;
}

library AutoMapping {
    function add(itmap storage self, uint value) internal returns (uint index) {
        index = self.size + 1;
        self.data[index].value = value;
        self.data[index].exists = true;
        self.size++;
    }
    function del(itmap storage self, uint key) internal returns (bool success) {
        delete self.data[key];
        self.deletedKeys.push(key);
        self.size--;
        return true;
    }
    function has(itmap storage self, uint key) internal view returns (bool) {
        return self.data[key].exists;
    }
    function get(itmap storage self, uint key) internal view returns (IndexValue storage) {
        return self.data[key];
    }
    function all(itmap storage self) internal view returns (uint[] memory items) {
        items = new uint[](self.size);
        uint j = 0;
        for (uint i = 1; i <= self.size; i++) {
            if (self.data[i].exists) {
                items[j] = self.data[i].value;
                j++;
            }
        }
    }
}

  struct Question {
    bytes url;
    uint16 level;
    uint16 year;
    address lecturer;
    string course;
}

struct IndexQuestionValue { bool exists; Question value; }

struct iqtmap {
    mapping(uint => IndexQuestionValue) data;
    uint[] deletedKeys;
    uint size;
}

library AutoQuestionMapping {
    function add(iqtmap storage self, Question memory value) internal returns (uint index) {
        index = self.size + 1;
        self.data[index].value = value;
        self.data[index].exists = true;
        self.size++;
    }
    function del(iqtmap storage self, uint key) internal returns (bool success) {
        delete self.data[key];
        self.deletedKeys.push(key);
        self.size--;
        return true;
    }
    function has(iqtmap storage self, uint key) internal view returns (bool) {
        return self.data[key].exists;
    }
    function get(iqtmap storage self, uint key) internal view returns (IndexQuestionValue storage) {
        return self.data[key];
    }
    function all(iqtmap storage self) internal view returns (Question[] memory items) {
        items = new Question[](self.size);
        uint j = 0;
        for (uint i = 1; i <= self.size; i++) {
            if (self.data[i].exists) {
                items[j] = self.data[i].value;
                j++;
            }
        }
    }
}