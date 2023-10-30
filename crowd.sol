// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

struct Fundraiser{
    string name;
    address payable fundraiserAddress;
    string fundraiserIdCard;
}
struct Donor{
    string name;
    address payable donorAddress;
    string donorIdCard;
}
struct FundTicket{
    string title;
    string details;
    bool activeStatus;
    uint fundAmount;
    uint currentCollection;
    address payable  fundraiserAddress;
}
