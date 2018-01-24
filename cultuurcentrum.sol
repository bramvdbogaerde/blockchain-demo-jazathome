contract Evenement {
   string name;
   uint available;
   
   // The tickets that are sold for this event
   Ticket[] tickets;

   // The wallet that organises the event
   EventWallet wallet;
}

contract Ticket {
   // The event for which the ticket was sold
   Evenement evenement;

   // The wallet that sold the ticket
   EventWallet wallet;

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
   address[] owners;

   // The list of events that are managed by this wallet
   Evenement[] evenement;

   // The list of tickets that are sold by this wallet
   Ticket[] tickets;

   /**
     * Only owner filter, scans the list of owners and checks that the sender is one of them
     *
     * @modifier
     */
   modifier only_owner() {
      // TODO: implement
   }

}
