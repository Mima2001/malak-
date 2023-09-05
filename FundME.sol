// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.18;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

contract FundMe{
  uint256 minimumUSD=5e18  ;
  address[]   public funders;
   mapping (address funder => uint256 AmountFunded) public AddressToAmountFunded;
   function fund() public payable  {
       //allow users to sand $
       //have a minimum $ sent
       //how de we send ETH to this contract?

       require(getConversionRate(msg.value > minimumUSD ,"did not send enough ETH")); // 1e18 = 1ETH = 1000000000
       // https://api
       funders.push(msg.sender);
       AddressToAmountFunded[msg.sender]=AddressToAmountFunded[msg.sender]+msg.value;
       
       
            

   }
  //function withdraw() public {}

  function getPrice() public view returns(uint256)   { 
    //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
    //ABI
    AggregatorV3Interface priceFeed= AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    (int256 price)=priceFeed.latestRoundData();
    //price of ETH IN TERMS OF USD
    //2000.000000000
    return uint256(price* 1e10);
  }
  function getConversionRate(uint256 ethAmount ) public view returns (uint256) {
    uint256 ethPrice  =getPrice();
    uint256 ethAmountInUsd=(ethPrice * ethAmount)/1e18;
    return ethAmountInUsd;
  }

  function getVersion public  view  returns(uint256){
    return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();

  }


}