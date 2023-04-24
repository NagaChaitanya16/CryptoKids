//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;
 

 contract CryptoKids {

                address owner;
        event logKidFundingReceived(address addr, uint amount, uint contractBalance);
                constructor(){
                    owner=msg.sender;
                }
             struct kid{
                             address payable walletAddr;
                             string firstName;
                             string lastName;
                             uint releaseAge;
                             uint amount;
                             bool canWithdraw;

             }

             

             modifier onlyOwner(){
                 require(msg.sender==owner, "You ain't owner");
                 _;
             }
         
             
 }
             function addKids(address payable walletAddr, string memory firstName, string memory lastName, uint releaseAge,uint amount, bool canWithdraw) onlyOwner public{
                 kids.push(kid(
                               
                               walletAddr,
                               firstName,
                               lastName,
                               releaseAge,
                               amount,
                               canWithdraw
                 ));
             } 

             function getBalofKid() public view returns(uint){

                 return address(this).balance;
             }

             function deposit(address walletAddr) payable public{
                 addToKidsBalance(walletAddr);

             }

             function addToKidsBalance(address walletAddr) private{
                 for (uint i=0; i<kids.length ;i++){
                     if(kids[i].walletAddr == walletAddr){
                         kids[i].amount+=msg.value;
                         emit logKidFundingReceived(walletAddr,msg.value, getBalofKid());
                     }
                 }
             }

             function getIndex(address walletAddr) view public returns(uint){
                 for(uint i=0; i<kids.length;i++){
                     if(kids[i].walletAddr==walletAddr){
                         return i;
                     }

                 }
                 return 0;
             }
                                
             function availableToWithdraw(address walletAddr) public returns(bool){
                    uint i= getIndex(walletAddr);
                    require(block.timestamp>kids[i].releaseAge);
                    if(block.timestamp > kids[i].releaseAge){
                        kids[i].canWithdraw=true;
                        return true;
                    }else{
                        return false;
                    }
             }

             function withdraw(address payable walletAddr) payable public {
                 uint i=getIndex(walletAddr);
                                  require(msg.sender==kids[i].walletAddr, "You must be the kid to withdraw!");
                            require(kids[i].canWithdraw==true, "Cannot withdraw at this time");
                 kids[i].walletAddr.transfer(kids[i].amount);
             }

             

            } 
 