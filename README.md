# SOC2025
Project Overview
As part of the Seasons of Code program, I developed a decentralized crowdfunding platform powered by Ethereum smart contracts. The aim was to explore how blockchain technology can enable transparent, community-driven campaign funding without relying on traditional intermediaries.

What I Explored
One of the biggest takeaways from this project was understanding how decentralized applications (dApps) differ from traditional ones. dApps run on public blockchains and are built to be open, trustless, and censorship-resistant, which makes them ideal for crowdfunding and similar use cases.

I also got hands-on experience with smart contracts, using Solidity to write the core logic for creating campaigns, managing contributors, and handling funds securely and automatically.

Solidity Concepts I Used

I used structs and mappings to organize and store campaign and contribution data efficiently.

Modifiers were useful for restricting access to sensitive actions like withdrawals and refunds.

I implemented payable functions to manage Ether contributions and withdrawals safely.

I relied on global variables like msg.sender, msg.value, and block.timestamp to build logic based on user identity, value transfer, and timing.

Development and Testing
I used Remix IDE for writing, testing, and debugging the smart contracts. It made it easy to simulate transactions, spot errors quickly, and ensure that the contract logic was both correct and gas-efficient.

Features I Built

Users can create fundraising campaigns by setting a goal and a deadline.

Anyone can contribute ETH to a campaign.

If a campaign reaches its goal, the creator can withdraw the funds.

If the goal isn’t met by the deadline, contributors can get their money back.

I added safety checks to prevent unauthorized access and common vulnerabilities like reentrancy.

What I Learned
This project helped me understand how to design and implement decentralized systems. I learned how to handle Ether safely, write secure smart contract logic, and follow best practices like the Checks-Effects-Interactions pattern. Most importantly, it helped me shift my mindset toward thinking from a security-first perspective.

I now feel confident building, testing, and deploying Solidity-based applications and look forward to continuing my journey in the Web3 space.

