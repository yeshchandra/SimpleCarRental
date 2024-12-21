// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// P2p car rental 

contract SimpleCarRental {
    struct Car {
        uint256 id;
        address payable owner;
        string details; // Combined make and model
        uint256 dailyRate; // Daily rental rate in wei
        bool isAvailable;
    }

    uint256 public carCount;
    mapping(uint256 => Car) public cars;

    event CarListed(uint256 carId, address indexed owner, string details, uint256 dailyRate);
    event CarRented(uint256 carId, address indexed renter, uint256 rentalDays);

    // List a car for rental
    function listCar(string memory _details, uint256 _dailyRate) public {
        require(_dailyRate > 0, "Daily rate must be greater than zero");

        carCount++;
        cars[carCount] = Car(carCount, payable(msg.sender), _details, _dailyRate, true);

        emit CarListed(carCount, msg.sender, _details, _dailyRate);
    }

    // Rent a car
    function rentCar(uint256 _carId, uint256 _rentalDays) public payable {
        Car storage car = cars[_carId];
        require(car.isAvailable, "Car is not available");
        require(msg.value == car.dailyRate * _rentalDays, "Incorrect payment amount");

        car.isAvailable = false;

        // Transfer payment to the owner
        car.owner.transfer(msg.value);

        emit CarRented(_carId, msg.sender, _rentalDays);
    }

    // Return a car to make it available again
    function returnCar(uint256 _carId) public {
        Car storage car = cars[_carId];
        require(!car.isAvailable, "Car is already available");

        car.isAvailable = true;
    }
}
