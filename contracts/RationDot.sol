// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract USersFeatures{
// THis will be the list of the item that are there inventory 

address public owner ; // This will store the address of the owner of the contract ;
     
  constructor() {
    // authorizedUsers[owner] = true;
    owner = msg.sender;
  }
   // this willl determine what tyoe of food we are storing and the address of the producer;
  struct Food {
    string name; 
    uint256 quantity;
    string foodType;
    address producer;
  }
  string[] public foodItemNames;
   // This will be the Benefeciary's data that is whether they are authorised or not will bbe mentioned by certain memebers of the government
  struct Beneficiary {
    string _name;
    address _theiraddress;
    bool authorization;   
  }
 
  event BeneficiaryAdded(address _beneficiary, string name);
  event FoodItemAdded(string _name , uint _quantity, string foodType , address sender);
 
  modifier onlyOwner() {  //Only Owner 
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

  mapping(string => Food) foodItems; // we can map the foodname as the key and the particular fooditem as its value 
  mapping(address => Beneficiary) beneficiaries; // we can map the benefeciaries to their address;
  mapping(address => string[]) public beneficiaryFoodItems; // This will keep the track of the all the foodItems that have been assigned to the benefeciary 
 

  function addBeneficiary(address _beneficiary, string memory _name) public onlyOwner {
    require(beneficiaries[_beneficiary]._theiraddress == address(0), "Beneficiary already exists");
    beneficiaries[_beneficiary] = Beneficiary(_name, _beneficiary, true); 
    emit BeneficiaryAdded(_beneficiary, _name);
  }
  
  function addFoodItem(string memory _name, uint256 _quantity, string memory foodType) public onlyOwner {
    require(foodItems[_name].quantity == 0, "A food item with this name already exists.");
    foodItems[_name] = Food(_name, _quantity, foodType, msg.sender);
    foodItemNames.push(_name);
    emit FoodItemAdded(_name, _quantity, foodType , msg.sender);
  }

  function viewRationAllotment(address beneficiary) public view returns(Food[] memory){
    require(beneficiaries[beneficiary].authorization == true, "Beneficiary not authorized");
    uint length = foodItemNames.length;
    Food[] memory allotedFood = new Food[](length);
    for(uint i = 0 ; i < length; i++){
      allotedFood[i] =  foodItems[beneficiaryFoodItems[beneficiary][i]]; // THis will check for all the foodITems that have been assigned to the beneficiary untill now 
    } 
    return allotedFood;
  }

  function updateRationAllotment(address beneficiary, uint256 newQuantity, string memory foodType) public onlyOwner{
    require(beneficiaries[beneficiary].authorization == true, "Beneficiary not authorized");
    foodItems[foodType].quantity = newQuantity;
  }

  function assignFoodItems(address beneficiary, string[] memory _foodItemNames) public onlyOwner {
    require(beneficiaries[beneficiary].authorization == true, "Beneficiary not authorized");
    for (uint i = 0 ; i < _foodItemNames.length; i++){
      require(foodItems[_foodItemNames[i]].quantity > 0, "One or more Food items are not available in inventory.");
    }
    beneficiaryFoodItems[beneficiary] = _foodItemNames;
  }
}

// * Making a stack based call