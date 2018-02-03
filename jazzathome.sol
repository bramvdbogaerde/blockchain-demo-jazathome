pragma solidity ^0.4.16;

import "cultuurcentrum.sol"

/**
 * A contract representing a confirmed reservation
 */
contract Reservation {
   address mOwner;

   // The wallet containing the reservation
   // This reference is kept to easily remove a reservation from the mapping there
   ReservationWallet mWallet;

   // Array of locations the user reserved through this reservation
   mapping (uint => Location) mLocations;
   
   modifier onlyOwner() {
      require(mOwner == msg.sender);
   }

   /**
     * Primary constructor
     * 
     * Passing the three locations indicates that a reservation is made for those tree locations
     */
   function Reservation(Location l1, Location l2, Location l3) {
      mLocations[0] = l1;
      mLocations[1] = l2;
      mLocations[2] = l3;
   }

   function getLocations() public view returns(mapping (uint => Location)) {
     return mLocations;
   }

   function cancelReservation() public onlyOwner() {
      
   }

}

contract Location {
   // the wallet that is associated with the location
   ReservationWallet mWallet;
  
   bytes32 name;

   // the total number of places on the location
   uint32 capacity;

   // the number of places reserved for this location
   uint32 reserved;   
   
}

/**
 * A wallet containing all the reservations for an event
 */
contract ReservationWallet {
   // The event for which the reservations are made
   Evenement mEvent;

   // The list of locations that can be reserved by a particular ticket
   Location[] mLocations;

   // A mapping between a ticket address and a reservation
   mapping (address => Reservation) mReservations;
   
}
