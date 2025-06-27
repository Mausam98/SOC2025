// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract CampaignFund {
    uint public totalCampaigns;
    bool private isLocked;

    struct Campaign {
        uint campaignId;
        address payable organizer;
        string campaignTitle;
        string campaignDetails;
        uint fundingGoal;
        uint expiryDate;
        uint currentFunds;
        bool fundsReleased;
        mapping(address => uint) donations;
    }

    mapping(uint => Campaign) public allCampaigns;
    mapping(uint => address[]) public donorRecords;

    event NewCampaign(uint campaignId, address indexed organizer, uint goal, uint deadline);
    event DonationReceived(uint campaignId, address indexed donor, uint amount);
    event GoalReachedAndWithdrawn(uint campaignId, address indexed organizer);
    event DonorRefunded(uint campaignId, address indexed donor, uint amount);

    modifier onlyOrganizer(uint _id) {
        require(msg.sender == allCampaigns[_id].organizer, "Not campaign organizer");
        _;
    }

    modifier campaignActive(uint _id) {
        require(block.timestamp < allCampaigns[_id].expiryDate, "Campaign expired");
        _;
    }

    modifier secure() {
        require(!isLocked, "Reentrant call blocked");
        isLocked = true;
        _;
        isLocked = false;
    }

    function startCampaign(
        string calldata _title,
        string calldata _details,
        uint _goal,
        uint _daysActive
    ) external {
        require(_goal > 0, "Goal must be positive");
        require(_daysActive >= 1 && _daysActive <= 90, "Campaign duration out of bounds");

        totalCampaigns++;
        uint id = totalCampaigns;

        Campaign storage newCampaign = allCampaigns[id];
        newCampaign.campaignId = id;
        newCampaign.organizer = payable(msg.sender);
        newCampaign.campaignTitle = _title;
        newCampaign.campaignDetails = _details;
        newCampaign.fundingGoal = _goal;
        newCampaign.expiryDate = block.timestamp + (_daysActive * 1 days);

        emit NewCampaign(id, msg.sender, _goal, newCampaign.expiryDate);
    }

    function donateToCampaign(uint _id) external payable campaignActive(_id) {
        require(msg.value > 0, "Donation required");

        Campaign storage campaign = allCampaigns[_id];
        if (campaign.donations[msg.sender] == 0) {
            donorRecords[_id].push(msg.sender);
        }

        campaign.donations[msg.sender] += msg.value;
        campaign.currentFunds += msg.value;

        emit DonationReceived(_id, msg.sender, msg.value);
    }

    function releaseFunds(uint _id) external onlyOrganizer(_id) secure {
        Campaign storage campaign = allCampaigns[_id];
        require(block.timestamp >= campaign.expiryDate, "Too early to withdraw");
        require(campaign.currentFunds >= campaign.fundingGoal, "Goal not achieved");
        require(!campaign.fundsReleased, "Already withdrawn");

        campaign.fundsReleased = true;
        (bool success, ) = campaign.organizer.call{value: campaign.currentFunds}("");
        require(success, "Withdrawal failed");

        emit GoalReachedAndWithdrawn(_id, msg.sender);
    }

    function claimRefund(uint _id) external secure {
        Campaign storage campaign = allCampaigns[_id];
        require(block.timestamp >= campaign.expiryDate, "Campaign still ongoing");
        require(campaign.currentFunds < campaign.fundingGoal, "Goal met, no refunds");

        uint donationAmount = campaign.donations[msg.sender];
        require(donationAmount > 0, "No donations to refund");

        campaign.donations[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: donationAmount}("");
        require(success, "Refund failed");

        emit DonorRefunded(_id, msg.sender, donationAmount);
    }

    function viewDonation(uint _id, address _donor) public view returns (uint) {
        return allCampaigns[_id].donations[_donor];
    }

    function listDonors(uint _id) public view returns (address[] memory) {
        return donorRecords[_id];
    }
}
