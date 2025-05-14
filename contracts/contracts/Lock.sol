// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Grantly {
    struct Campaign {
        address creator;
        string title;
        string description;
        uint goal;
        uint deadline;
        uint amountRaised;
        bool completed;
    }

    mapping(uint => Campaign) public campaigns;
    uint public campaignCount;

    event CampaignCreated(uint id, address creator, string title, uint goal, uint deadline);
    event DonationReceived(uint id, address donor, uint amount);

    function createCampaign(string memory _title, string memory _description, uint _goal, uint _durationInDays) public {
        require(_goal > 0, "Goal must be positive");
        uint deadline = block.timestamp + (_durationInDays * 1 days);

        campaigns[campaignCount] = Campaign(msg.sender, _title, _description, _goal, deadline, 0, false);
        emit CampaignCreated(campaignCount, msg.sender, _title, _goal, deadline);
        campaignCount++;
    }

    function donate(uint _id) public payable {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp < campaign.deadline, "Campaign ended");
        require(!campaign.completed, "Campaign already completed");
        require(msg.value > 0, "Donation must be positive");

        campaign.amountRaised += msg.value;

        if (campaign.amountRaised >= campaign.goal) {
            campaign.completed = true;
        }

        emit DonationReceived(_id, msg.sender, msg.value);
    }

    function withdrawFunds(uint _id) public {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "Only creator can withdraw");
        require(campaign.amountRaised >= campaign.goal, "Goal not reached");
        require(campaign.completed, "Campaign not completed yet");

        uint amount = campaign.amountRaised;
        campaign.amountRaised = 0;
        payable(msg.sender).transfer(amount);
    }
}
