// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "contracts/crowdFunding/crowd.sol";

contract CrowdFunding{
    address payable fundManager; // contract manager
Fundraiser fundraiserBlock;
Donor donorBlock;
FundTicket public  ticket;

//mapping for registration//
uint fundraiserIndex;
uint donorIndex;
mapping (uint=> Fundraiser) fundraiserList;
mapping(uint=>Donor) donorList;

constructor() payable {
    fundManager = payable (msg.sender);
    fundraiserIndex = 0;
    donorIndex = 0;
}
//***************modifiers**************
modifier checkFundManager(){
    require(msg.sender ==fundManager,"Action deny... Invalid User Account");
    _;
}
modifier checkFundraiserRegister(){
    bool token = false;
    uint regCount = 0;
    while (regCount < fundraiserIndex){
       if (fundraiserList[regCount].fundraiserAddress == msg.sender)
       {
        token = true;
        break;
       }
       regCount++;
    }
require(token == false,"Fundraiser Account Already Exists");
_;
}
modifier checkDonorRegister(){
    bool token = false;
    uint regCount = 0;
    while (regCount < donorIndex){
       if (donorList[regCount].donorAddress == msg.sender)
       {
        token = true;
        break;
       }
       regCount++;
    }
require(token == false,"Donor Account Already Exists");
_;
}
modifier isFundraiserRegisterExists(){
    bool token = false;
    uint regCount = 0;
    while (regCount < fundraiserIndex){
       if (fundraiserList[regCount].fundraiserAddress == msg.sender)
       {
        token = true;
        break;
       }
       regCount++;
    }
require(token == true,"Fundraiser Account Not Exists");
_;
}
modifier checkFundTicketStatus(){
    require(ticket.activeStatus==false,"Funding Ticket Already Exists");
    _;
}
modifier isDonorRegisterExists(){
    bool token = false;
    uint regCount = 0;
    while (regCount < donorIndex){
       if (donorList[regCount].donorAddress == msg.sender)
       {
        token = true;
        break;
       }
       regCount++;
    }
require(token == true,"Donor Account Not Exists");
_;
}
modifier isFundTicketStatus(){
    require(ticket.activeStatus==true,"Funding Ticket Not Exists");
    _;
}
modifier checkDonateAmount(uint ethAmount){
    uint amount = ethAmount * 1000000000000000000;
    require(ethAmount == msg.value, "Invalid Amount Please Check The Transaction...");
    _;
}
 modifier checkReleaseFundAmount(){
    uint amount = ticket.currentCollection * 1000000000000000000;
     require(amount == msg.value, "Invalid Amount Please Check The Donation Amount...");
    _;
 }

//**********Functions***************/
function fundraiserRegister(string memory name, string memory userIdCard) payable public checkFundraiserRegister() {
    fundraiserBlock = Fundraiser(name,payable (msg.sender), userIdCard);
    fundraiserList[fundraiserIndex] = fundraiserBlock; 
    fundraiserIndex++;
} 
function donorRegister(string memory name, string memory userIdCard) payable public checkDonorRegister() {
    donorBlock = Donor(name, payable (msg.sender), userIdCard);
    donorList[donorIndex] = donorBlock;
    donorIndex++;
}
function raiseFundTicket(string memory title, uint fundAmount, string memory details) payable  public checkFundTicketStatus() isFundraiserRegisterExists() {
 ticket = FundTicket(title, details,true,fundAmount,0,payable (msg.sender));

}
function donateNow(uint ethAmount) payable public isDonorRegisterExists() isFundTicketStatus() checkDonateAmount(ethAmount) {
    uint currentFunds = ticket.currentCollection;
    currentFunds += ethAmount;
    fundManager.transfer(msg.value);
    ticket.currentCollection = currentFunds;
    if (ticket.fundAmount >= ticket.currentCollection){
        ticket.activeStatus = false;
    }
}
function releaseFundAmount() payable public checkFundManager() checkReleaseFundAmount() {
    ticket.fundraiserAddress.transfer(msg.value);
}
}