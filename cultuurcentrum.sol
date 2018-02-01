pragma solidity ^0.4.16;

contract Evenement {
   string mName;
   uint mAvailable;
   

   // The tickets that are sold for this event
   Ticket[] mTickets;

   // The wallet that organises the event
   EventWallet mWallet;

   /**
     * Primary constructor of the event
     * This should be called from an EventWallet
     */
   function Evenement(string name, uint available, EventWallet w) public {
      mName = name;
      mAvailable = available;
      mWallet = w;
   }
}

contract Ticket {
   // The event for which the ticket was sold
   Evenement evenement;

   // The owner of the ticket
   address owner;
}

/**
 * A wallet that contains a list of Evenement
 * and is able to sell tickets for them
 *
 * A third party should contact the EventWallet
 * when it wants to know if a ticket-evenement combination is valid
 */
contract EventWallet{
   // A list of owners that own the wallet
   // An owner is allowed to change events, add them and delete them
   address[] mOwners;

   // The list of events that are managed by this wallet
   Evenement[] mEvenement;

   // The list of tickets that are sold by this wallet
   Ticket[] mTickets;

   /**
     * Primary constructor, used to initialize the internal data structures
     */
   function EventWallet() public {
      // Add the creator of the wallet to the owner list
      mOwners.push(msg.sender);
   }

   function isOwner(address p) public view returns(bool) {
      // An akward way in solidity to check if a certain key exists in the mapping
      // That is because there is not a function "contains" for mappings in Solidity
      return mOwners[uint256(p)] > 0;
   }

   /**
     * Only owner filter, scans the list of owners and checks that the sender is one of them
     */
   modifier only_owner() {
      require(isOwner(msg.sender));
      _;
   }

   /**
     * Create and add an event to the wallet
     * 
     * @param name the name of the new event
     * @param available_places the number of people that can attend the event
     * @return the addres of the created event
     */
   function addEvent(string name, uint available_places) only_owner() public returns(address)  {
      Evenement e = new Evenement(name, available_places, this);
      mEvenement.push(e);
      return e;
   }

}
