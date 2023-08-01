## Project Exam Submissions

This smart contract is designed for use on a private blockchain and hence no optimizations were made for storage since there isn't any incentive to do that. Also it prevents the need to have an indexer arranging data and everything is accomplished within the smart contract.

### Usage

- `npm i` to install all the dependencies
- `npm run compile` to compile all the contracts
- `npm run tests` to run all the tests
- `npm run deploy` to deploy to the local hardhat network
- `npm run deploy:sepolia` to deploy to the sepolia network

### Requirements

A smart contract backend to satisfy the following requirements;

1. The lecturers will enter their ids that will be stored on the blockchain to be able to access their accounts. After logging in, they have a page where they can upload their questions.
 
2. The Photocopy unit have a page where they can access by typing in their ids in order to retrieve the questions for printing. The questions will be displayed based on the year selected.
 
3. The HOD will enter his id number to be able to access a page displaying all the uploaded questions based on the year just as the photocopy unit page.
 
4. There will be a table for lecturers containing their names, id numbers, and Gmail accounts and there will also be another table for the photocopy unit containing their names and id numbers.
 
5. There will also be a table for courses where the courses are arranged based on the years that offer the various courses, so it can help with the display on the photocopy unit and HOD page.
 
6. Only the HOD and Photocopy unit has access to the various courses and their questions. The lecturers only have access to the submissions they made on their page.

7. We are having problems with the source of the credentials the HOD, photocopy unit and the lecturers are going use for their logins. Either they could be automatically generated or they are inputted by the HOD. If you have a more appropriate method, please do use it.


### Blockchain Implementation Requirements Modifications

Each point here is an answer to one of the points above.

1. Each lecture will be assumed to have a wallet which will be the sole means for authenticaion.

2. Photocopy unit will also be assumed to have a wallet which will be used for authentication.

3. HOD will also be assumed to have a wallet which will be used for authentication.

4. A struct will be used to store extra details of the lectures & photocopy unit personal data and a map from address to the struct will be created.

5. There will be a data structures designed to store course,  year, level, and question. A distinction is made between year and level where the level is the level of the students
    100, 200, 300, 400 etc ... and year is the calender year of the questions like 2001, 2002

6. This is ideally not a blockchain application but for the project's sake a public blockchain is being used. In real life a private blockchain should be used.

7. As metioned in the points above, a wallet would be used for authentication, therefore it would be assumed that all entities posses a wallet. There would be and admin/owner of the contract who can add remove and update users in the system including the HOD.


#### Contract & Integrations

- Since files cannot directly be uploaded to the smart contract only url of files should be uploaded.

- Any service can be used to upload files and generate the urls but it is recommended to use ipfs in the integraton.

- A mapping from address to boolean will be used to store lectures who are authenticated within the system. Same for photocopy unit personel.

- Smart contract will have appropriate data structures keep track of the courses, year, level, questions. Question will be a struct like { string url }

- There is also the need to keep track of all questions uploaded by a lecturer

- courses are represented as a string hence there is flexibility in how they can be used. A recommendation would be to use the course code to represent the course. This is better than just the course name since it 

#### Data Structures

In order to efficiently store and retrieve questions, some necessary data structures must be implemented to make this fast. Space optimization is not necessary in this contract. Aside just storing the questions, the contract will need to keep track of which lecturer uploaded the question, which year, level and course. The following functionalities should be possible;

1. Retrieve questions uploaded by a lecturer.

2. Retrieve questions uploaded in a particular year.

3. Retrieve questions uploaded in a particular level.

4. Retrieve questioins uploaded in for a particular course.

#### Deployments
1. Deployed To sepolia network https://sepolia.etherscan.io/address/0xDdd66E1590539F06f7190B0823fA48cD7CFdfBf6 
```json
{
  "_type": "TransactionReceipt",
  "accessList": [],
  "blockNumber": null,
  "blockHash": null,
  "chainId": "11155111",
  "contractAddress": "0xDdd66E1590539F06f7190B0823fA48cD7CFdfBf6",
  "from": "0xb3fAED28554eF9F249873Bae907564cFB20410b6",
  "gasLimit": "1740833",
  "gasPrice": "7605710",
  "hash": "0x10a493039c4a2c29d5de470420caf20d688d7586a732c703c7ef20e98eb7b126",
  "maxFeePerGas": "7605710",
  "maxPriorityFeePerGas": "4638417",
  "nonce": 23,
  "signature": {
    "_type": "signature",
    "networkV": null,
    "r": "0x0acfab2ebf5a21994afa5080f659dea288090df067876bd89c01942e934ca587",
    "s": "0x16883470838e83aebd09ad28342d65c6a2282234f90faf7ea25a57e16db896a1",
    "v": 28
  },
  "to": null,
  "type": 2,
  "value": "0"
}

```