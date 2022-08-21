// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Urun is Ownable{
    using Counters for Counters.Counter;
    Counters.Counter private _IdApplicationCounter;
    Counters.Counter private _IdDonationCounter;

    enum fundStatus {Created, Launch, Completed, notAchieved}
    fundStatus fstatus;
    enum donationStatus {Ongoing, Completed, Failed}
    donationStatus dstatus;


    struct fundDetail{
        string event_name;
        string event_description;
        string time_expired;
        fundStatus status;
        uint256 amount_needed;
        address fundraiser;
    }

    struct donationDetail{
        uint256 idApplication;
        donationStatus dstatus;
        uint256 amount;
    }

    mapping(uint256 => fundDetail) public FundLists;
    mapping(uint256 => donationDetail) public Donations;
    mapping(address => mapping(uint256 => uint256)) public Contributors;
    //mapping(address => mapping(address => bool)) approved;

    //event 

    function makeFundApplication(
        string memory event_name_,
        string memory event_description_, 
        string memory time_expired_,
        uint256 amount_needed_,
        address fundraiser_
    ) external onlyOwner returns(uint256){
        uint256 idApplication = _IdApplicationCounter.current();
        _IdApplicationCounter.increment();
        
        fstatus = fundStatus.Created;
        
        FundLists[idApplication]= fundDetail(event_name_, event_description_, time_expired_, fstatus, amount_needed_, fundraiser_);
        return idApplication;
    }

    function launchFunding(
        uint256 idApplication_
    )external onlyOwner returns(bool){
        //if already donation ongoing, break
        //if idApllication tidak ada maka break
        uint256 idDonation = _IdDonationCounter.current();
        _IdDonationCounter.increment();

        fstatus = fundStatus.Launch;
        dstatus = donationStatus.Ongoing;

        //address null_address;


        Donations[idDonation]= donationDetail(idApplication_, dstatus, 0);
        FundLists[idApplication_].status= fstatus;
        return true;
    }

    function sendDonation(
        uint256 idDonation_,
        uint256 amount_,
        uint256 epochTime_
    ) external returns(bool) {
        //require not expire
        //idapplication status is launched
        //doantion status is ongoing
        //check if donatur/contributor sudah berdonasi, sekarang tidak boleh donasi lebihd ari 1x


        address contributor_ = _msgSender();
        uint256 amountNeeded = FundLists[idDonation_].amount_needed;
        uint256 amountNow = Donations[idDonation_].amount;              // amount yang sudah terkumpul sampai sekarang
        

        //if amountnow >= amountneeded => amount yang dibutuhkan sudah tercukupi. penggalangan dana berakhir.
        //  set Fundlist => Completed, set Donations => Completed;
        //if amount > amount needed - amountNow => jumlah amount terlalu besar, return false
        //if check epochTime_ >= Fundlist.time_expired   
        //  set Fundlist => notAchieved, set Donations => failed; 

        // mekanisme approval dan transfer
        Donations[idDonation_].amount = amountNow + amount_;
        Contributors[contributor_][idDonation_] = amount_;

        
        
        return true;

    }

    function finalizeDonations(
        idDonation_

    )

    function 

}