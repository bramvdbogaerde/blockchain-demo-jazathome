pragma solidity ^0.4.16;

import "cultuurcentrum.sol";

/**
 * A contract representing a confirmed reservation
 */
contract Reservation {
   // The ticket for which the reservation was made
   Ticket mTicket;

   // The wallet containing the reservation
   // This reference is kept to easily remove a reservation from the mapping there
   ReservationWallet mWallet;

   // Array of locations the user reserved through this reservation
   Location[] mLocations;
   

   /**
     * Primary constructor
     * 
     * Passing the three locations indicates that a reservation is made for those tree locations
     */
   function Reservation(Location l1, Location l2, Location l3, Ticket t) public {
      mLocations.push(l1);
      mLocations.push(l2);
      mLocations.push(l3);

      mTicket = t;
   }

   /**
     * Get the owner of the reservation
     * 
     * @return the owner of the reservation
     */
   function getTicket() public view returns(Ticket) {
      return mTicket;
   }

   /**
     * @return the locations that were reserved for this reservation
     */
   function getLocations() public view returns(Location[]) {
     return mLocations;
   }

}

contract Location {
   // the wallet that is associated with the location
   ReservationWallet mWallet;

   // the reservations made for this location
   Reservation[] mReservations;

   // The name of the location
   bytes32 name;

   // the total number of places on the location
   uint32 capacity;

   // the number of places reserved for this location
   uint32 reserved;   
   
   /**
     * Check if the location can be reserved
     * 
     * @param places the number of places that need to be reserved
     * @return a boolean indicating that enough places are available for this location
     */
   function canReserve(uint32 places) public view returns(bool){
      return reserved+places < capacity;
   }


   function reserveLocation(Reservation r) public {
      require(reserved != capacity);
      require(mWallet.hasReservation(r.getTicket()));

      reserved += 1;
      mReservations.push(r);
   }

   function getName() public view returns(bytes32){
      return name;
   }

   function Location(bytes32 n, uint32 c, ReservationWallet wallet) public {
      name = n;
      capacity = c;
      reserved = 0;
      mWallet = wallet;
   }

}


/**
 * A wallet containing all the reservations for an event
 */
contract ReservationWallet {
   address mOwner;

   // The event for which reservations can be made
   Evenement mEvent;

   modifier onlyOwner(){
      require(msg.sender == mOwner);
      _;
   }

   // The list of locations that can be reserved by a particular ticket
   Location[] mLocations;

   // A mapping between a ticket address and a reservation
   mapping (address => Reservation) mReservations;

   function ReservationWallet(Evenement e) public {
      mEvent = e;
      mOwner = msg.sender;
   }
 
   /**
     * Check if the specified ticket has a reservation
     *
     * @param owner of the reservation
     * @return a boolean indicating that a reservations exists under the specified address
     */
   function hasReservation(address owner) public view returns(bool) {
      return mReservations[owner] > address(0);
   }

   function getReservation(address ticket) public view returns(Reservation){
      return mReservations[ticket];
   }

   /**
     * Reserve tree locations
     *
     * @param l1 the first location
     * @param l2 the second location
     * @param l3 the third location
     * @return the new reservation
    */
   function reserve(Location l1, Location l2, Location l3, Ticket t) public returns(address) {
      // only the owner of a ticket can reserve the locations of a ticket
      require(t.getOwner() == msg.sender);

      require(l1.canReserve(1) && l2.canReserve(1) && l3.canReserve(1));

      // We check against the event if the ticket was sold for it instead of looking this
      // information up from the ticket itself.
      // Because a ticket can be indepently created from the event
      require(mEvent.hasTicket(t));

      Reservation r = new Reservation(l1, l2, l3, t);
      mReservations[t] = r;

      l1.reserveLocation(r);
      l2.reserveLocation(r);
      l3.reserveLocation(r);

      return address(r);
   }

   function getLocations() public view returns(Location[]){
      return mLocations;
   }

   function addLocation(bytes32 name, uint32 capacity) public onlyOwner() returns(address){
      Location l = new Location(name, capacity, this);
      mLocations.push(l);

      return address(l);
   }
}
