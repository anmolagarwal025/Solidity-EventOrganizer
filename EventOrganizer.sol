//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EventOragnizer
{
    struct Event
    {
        address organizer;
        string name;
        uint date;
        uint ticketPrice;
        uint ticketCount;
        uint ticketRemaning;
    }

    mapping(uint=>Event) public events;
    uint public nextid;

    mapping(address=>mapping(uint=>uint)) public tickets;

    function createEvent(string memory _name, uint _date, uint _ticketPrice, uint _ticketCount) external
    {
        require(_date > block.timestamp, "Event can't be book in past..");
        require(_ticketCount > 0, "Ticket can't be zero..");
        events[nextid] = Event(msg.sender, _name, _date, _ticketPrice, _ticketCount, _ticketCount);
        nextid++;
    }

    function buyTicket(uint id, uint ticketQuantity) external payable
    {
     require(events[id].date!=0, "Event has occured..");
     require(events[id].date > block.timestamp, "Event can't be book in past..");
     require(ticketQuantity > 0, "You must have atleast one ticket..");
     require(events[id].ticketRemaning >= ticketQuantity, "Not enough tickets remaining...");
     Event storage _events = events[id];
     require(msg.value > (_events.ticketPrice*ticketQuantity));
     tickets[msg.sender][id]+=ticketQuantity;
     events[id].ticketRemaning-=ticketQuantity;
    }

    function transferTicket(uint id, address to, uint transferQuantity) external
    {
        require(events[id].date!=0, "Event has occured..");
        require(events[id].date > block.timestamp, "Event can't be book in past..");
        require(tickets[msg.sender][id] >= transferQuantity, "You don't have enough ticket to transfer");
        tickets[msg.sender][id]-=transferQuantity;
        tickets[to][id]+=transferQuantity;
    } 
}